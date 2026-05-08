#include <gtk/gtk.h>
#include <gtk-layer-shell/gtk-layer-shell.h>
#include <gio/gio.h>
#include <gio/gdesktopappinfo.h>
#include <glib.h>
#include <string.h>

// Constants
#define ICON_SIZE 48
#define ICON_WIDTH 110
#define ICON_HEIGHT 100
#define MAX_LABEL_LEN 15
#define WRAPPED_LABEL_LEN 12
#define GRID_COLUMN_SPACING 20
#define GRID_ROW_SPACING 15
#define WINDOW_MARGIN 20

// Type definitions
typedef struct {
    GtkGrid *grid;
    GList *icons;
    int icons_per_column;
} DesktopIcons;

// Function prototypes
static GdkPixbuf* load_icon_for_file(const char *filepath);
static GtkWidget* create_icon_widget(const char *filepath);
static gboolean on_icon_double_click(GtkWidget *widget, GdkEventButton *event, gpointer user_data);
static void apply_css_styling(GtkWidget *widget, const char *css);
static void reload_grid_layout(DesktopIcons *desktop);
static void add_icon(DesktopIcons *desktop, const char *filepath);
static void load_desktop_files(DesktopIcons *desktop);
static void calculate_icons_per_column(DesktopIcons *desktop, GtkWidget *window);
static void setup_layer_shell_window(GtkWidget *window);
static void cleanup(DesktopIcons *desktop);

static void apply_css_styling(GtkWidget *widget, const char *css) {
    GtkStyleContext *context = gtk_widget_get_style_context(widget);
    GtkCssProvider *provider = gtk_css_provider_new();
    
    gtk_css_provider_load_from_data(provider, css, -1, NULL);
    gtk_style_context_add_provider(context, GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    g_object_unref(provider);
}

static GdkPixbuf* load_desktop_file_icon(const char *filepath, GtkIconTheme *theme) {
    char *contents = NULL;
    GError *error = NULL;
    GdkPixbuf *pixbuf = NULL;
    
    if (!g_file_get_contents(filepath, &contents, NULL, &error)) {
        if (error) g_error_free(error);
        return NULL;
    }
    
    char **lines = g_strsplit(contents, "\n", -1);
    for (int i = 0; lines[i]; i++) {
        if (g_str_has_prefix(lines[i], "Icon=")) {
            char *icon_value = lines[i] + 5;
            
            // Trim whitespace
            while (g_ascii_isspace(*icon_value)) icon_value++;
            char *end = icon_value + strlen(icon_value) - 1;
            while (end > icon_value && g_ascii_isspace(*end)) *end-- = '\0';
            
            if (strlen(icon_value) > 0) {
                // Check if it's a file path (contains '/' or ends with .png/.svg/.xpm)
                if (strchr(icon_value, '/') || g_str_has_suffix(icon_value, ".png") || g_str_has_suffix(icon_value, ".svg") || g_str_has_suffix(icon_value, ".xpm")) {
                    // It's a file path - load directly
                    if (g_file_test(icon_value, G_FILE_TEST_EXISTS)) {
                        pixbuf = gdk_pixbuf_new_from_file_at_size(icon_value, ICON_SIZE, ICON_SIZE, NULL);
                    }
                } else if (gtk_icon_theme_has_icon(theme, icon_value)) {
                    pixbuf = gtk_icon_theme_load_icon(theme, icon_value, ICON_SIZE, GTK_ICON_LOOKUP_FORCE_SIZE, NULL);
                }
            }
            break;
        }
    }
    
    g_strfreev(lines);
    g_free(contents);
    return pixbuf;
}

// Create a fallback icon (gray square)
static GdkPixbuf* create_fallback_icon(void) {
    GdkPixbuf *pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, TRUE, 8, ICON_SIZE, ICON_SIZE);
    gdk_pixbuf_fill(pixbuf, 0x888888FF);
    return pixbuf;
}

static GdkPixbuf* load_icon_for_file(const char *filepath) {
    GtkIconTheme *theme = gtk_icon_theme_get_default();
    GdkPixbuf *pixbuf = NULL;
    
    if (g_str_has_suffix(filepath, ".desktop")) {
        pixbuf = load_desktop_file_icon(filepath, theme);
        if (pixbuf) return pixbuf;
    }
    
    // Return fallback icon for all other files
    return create_fallback_icon();
}

static char* create_display_text(const char *filepath) {
    char *basename = g_path_get_basename(filepath);
    char *display_text;
    
    // Remove .desktop extension for display
    char *dot_desktop = strstr(basename, ".desktop");
    if (dot_desktop) {
        *dot_desktop = '\0';
    }
    
    if (strlen(basename) > MAX_LABEL_LEN) {
        char *temp = g_strndup(basename, WRAPPED_LABEL_LEN);
        display_text = g_strdup_printf("%s...", temp);
        g_free(temp);
    } else {
        display_text = g_strdup(basename);
    }
    
    g_free(basename);
    return display_text;
}

static GtkWidget* create_icon_widget(const char *filepath) {
    GdkPixbuf *pixbuf = load_icon_for_file(filepath);
    char *display_text = create_display_text(filepath);
    
    // Create container grid
    GtkWidget *grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 8);
    
    // Create image and label
    GtkWidget *image = gtk_image_new_from_pixbuf(pixbuf);
    GtkWidget *label = gtk_label_new(display_text);
    
    g_object_unref(pixbuf);
    g_free(display_text);
    
    // Configure label
    gtk_label_set_line_wrap(GTK_LABEL(label), TRUE);
    gtk_label_set_max_width_chars(GTK_LABEL(label), WRAPPED_LABEL_LEN);
    gtk_label_set_xalign(GTK_LABEL(label), 0.5);
    gtk_label_set_yalign(GTK_LABEL(label), 0.5);
    
    // Assemble widget
    gtk_grid_attach(GTK_GRID(grid), image, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), label, 0, 1, 1, 1);
    
    // Make it clickable with double-click
    GtkWidget *event_box = gtk_event_box_new();
    gtk_container_add(GTK_CONTAINER(event_box), grid);
    
    // Store filepath in the widget
    g_object_set_data_full(G_OBJECT(event_box), "filepath", 
                          g_strdup(filepath), g_free);
    
    // Connect double-click event
    g_signal_connect(event_box, "button-press-event", 
                     G_CALLBACK(on_icon_double_click), NULL);
    
    apply_css_styling(grid,
        "grid {"
            "background-color: transparent;"
            "padding: 8px;"
            "border-radius: 5px;"
        "}"
        "grid:hover {"
            "background-color: rgba(255, 255, 255, 0.1);"
        "}"
    );
    
    apply_css_styling(label,
        "label {"
            "color: white;"
            "text-shadow: 1px 1px 2px black;"
            "font-size: 11px;"
            "font-weight: bold;"
        "}"
    );
    
    gtk_widget_set_size_request(event_box, ICON_WIDTH, ICON_HEIGHT);
    return event_box;
}

static gboolean on_icon_double_click(GtkWidget *widget, GdkEventButton *event, gpointer user_data) {
    // Only trigger on double-click
    if (event->type != GDK_2BUTTON_PRESS || event->button != 1) {
        return FALSE;
    }
    
    char *filepath = g_object_get_data(G_OBJECT(widget), "filepath");
    if (!filepath) {
        return FALSE;
    }
    
    GFile *file = g_file_new_for_path(filepath);
    gchar *uri = g_file_get_uri(file);
    GError *error = NULL;
    gboolean launched = FALSE;
    
    if (!g_file_query_exists(file, NULL)) {
        goto cleanup;
    }
    
    // Try launching .desktop file
    if (g_str_has_suffix(filepath, ".desktop")) {
        GDesktopAppInfo *app_info = g_desktop_app_info_new_from_filename(filepath);
        if (app_info) {
            GAppLaunchContext *context = g_app_launch_context_new();
            launched = g_app_info_launch(G_APP_INFO(app_info), NULL, context, &error);
            g_object_unref(context);
            g_object_unref(app_info);
        }
    }
    
    // Try default handler for URI
    if (!launched) {
        launched = g_app_info_launch_default_for_uri(uri, NULL, &error);
    }
    
    // Fallback to xdg-open
    if (!launched) {
        const char *argv[] = {"xdg-open", filepath, NULL};
        launched = g_spawn_async(NULL, (char**)argv, NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, NULL, &error);
    }
    
    if (error) {
        g_warning("Failed to launch %s: %s", filepath, error->message);
        g_error_free(error);
    }
    
cleanup:
    g_free(uri);
    g_object_unref(file);
    
    return TRUE;
}

static void reload_grid_layout(DesktopIcons *desktop) {
    int total = g_list_length(desktop->icons);
    
    // Clear existing children
    GList *children = gtk_container_get_children(GTK_CONTAINER(desktop->grid));
    for (GList *child = children; child != NULL; child = child->next) {
        gtk_container_remove(GTK_CONTAINER(desktop->grid), GTK_WIDGET(child->data));
    }
    g_list_free(children);
    
    // Add icons in grid formation (column-major order)
    for (int i = 0; i < total; i++) {
        int column = i / desktop->icons_per_column;
        int row = i % desktop->icons_per_column;
        
        GtkWidget *icon = GTK_WIDGET(g_list_nth_data(desktop->icons, i));
        gtk_grid_attach(desktop->grid, icon, column, row, 1, 1);
    }
    
    gtk_widget_show_all(GTK_WIDGET(desktop->grid));
}

static void add_icon(DesktopIcons *desktop, const char *filepath) {
    GtkWidget *icon = create_icon_widget(filepath);
    desktop->icons = g_list_append(desktop->icons, icon);
}

static void load_desktop_files(DesktopIcons *desktop) {
    const char *desktop_path = g_get_user_special_dir(G_USER_DIRECTORY_DESKTOP);
    if (!desktop_path) {
        g_warning("Could not find desktop directory");
        return;
    }
    
    GError *error = NULL;
    GDir *dir = g_dir_open(desktop_path, 0, &error);
    
    if (!dir) {
        g_warning("Failed to open desktop directory: %s", error->message);
        g_error_free(error);
        return;
    }
    
    const char *filename;
    while ((filename = g_dir_read_name(dir))) {
        if (filename[0] != '.') {
            char *full_path = g_build_filename(desktop_path, filename, NULL);
            add_icon(desktop, full_path);
            g_free(full_path);
        }
    }
    
    g_dir_close(dir);
}

static void calculate_icons_per_column(DesktopIcons *desktop, GtkWidget *window) {
    GdkScreen *screen = gtk_widget_get_screen(window);
    int screen_height = gdk_screen_get_height(screen);
    int available_height = screen_height - (2 * WINDOW_MARGIN);
    
    desktop->icons_per_column = (available_height + GRID_ROW_SPACING) / (ICON_HEIGHT + GRID_ROW_SPACING);
    if (desktop->icons_per_column < 1) desktop->icons_per_column = 1;
}

static void setup_layer_shell_window(GtkWidget *window) {
    gtk_layer_init_for_window(GTK_WINDOW(window));
    gtk_layer_set_namespace(GTK_WINDOW(window), "desktop-icons");
    gtk_layer_set_layer(GTK_WINDOW(window), GTK_LAYER_SHELL_LAYER_BOTTOM);
    
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, TRUE);
    
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, WINDOW_MARGIN);
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, WINDOW_MARGIN);
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, WINDOW_MARGIN);
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, WINDOW_MARGIN);
}

static void cleanup(DesktopIcons *desktop) {
    if (desktop->icons) {
        for (GList *l = desktop->icons; l != NULL; l = l->next) {
            gtk_widget_destroy(GTK_WIDGET(l->data));
        }
        g_list_free(desktop->icons);
    }
    g_free(desktop);
}

// Main application activation handler
static void activate(GtkApplication *app, gpointer user_data) {
    DesktopIcons *desktop = g_new0(DesktopIcons, 1);
    
    // Create main window
    GtkWidget *window = gtk_application_window_new(app);
    setup_layer_shell_window(window);
    
    // Calculate layout
    calculate_icons_per_column(desktop, window);
    
    // Create scrolled window
    GtkWidget *scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    
    // Create grid for icons
    desktop->grid = GTK_GRID(gtk_grid_new());
    gtk_grid_set_column_spacing(desktop->grid, GRID_COLUMN_SPACING);
    gtk_grid_set_row_spacing(desktop->grid, GRID_ROW_SPACING);
    
    load_desktop_files(desktop);
    reload_grid_layout(desktop);
    
    gtk_container_add(GTK_CONTAINER(scrolled_window), GTK_WIDGET(desktop->grid));
    gtk_container_add(GTK_CONTAINER(window), scrolled_window);
    
    apply_css_styling(window,
        "window, window.background {"
            "background-color: transparent;"
        "}"
    );
    
    apply_css_styling(scrolled_window,
        "scrolledwindow, scrolledwindow.viewport {"
            "background-color: transparent;"
        "}"
    );
    
    gtk_widget_show_all(window);
    g_signal_connect_swapped(window, "destroy", G_CALLBACK(cleanup), desktop);
}

int main(int argc, char **argv) {
    GtkApplication *app = gtk_application_new("com.example.icons", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    
    return status;
}
