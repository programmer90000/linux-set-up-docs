#include <gtk/gtk.h>
#include <gtk-layer-shell/gtk-layer-shell.h>
#include <gio/gio.h>
#include <gio/gdesktopappinfo.h>
#include <glib.h>
#include <cairo.h>

static GtkGrid *icon_grid = NULL;
static GList *all_icons = NULL;
static int icons_per_column = 5;

static void apply_css_styling(GtkWidget *widget, const char *css) {
    GtkStyleContext *context = gtk_widget_get_style_context(widget);
    GtkCssProvider *provider = gtk_css_provider_new();
    
    gtk_css_provider_load_from_data(provider, css, -1, NULL);
    gtk_style_context_add_provider(context, GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    g_object_unref(provider);
}

static GdkPixbuf* load_icon_for_file(const char *filepath) {
    GdkPixbuf *pixbuf = NULL;
    
    if (g_str_has_suffix(filepath, ".desktop")) {
        char *contents;
        GError *error = NULL;
        
        if (g_file_get_contents(filepath, &contents, NULL, &error)) {
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
                                pixbuf = gdk_pixbuf_new_from_file_at_size(icon_value, 48, 48, NULL);
                                if (pixbuf) {
                                    g_print("Loaded icon from path: %s\n", icon_value);
                                }
                            }
                        } else {
                            // It's an icon name - look up in theme
                            GtkIconTheme *theme = gtk_icon_theme_get_default();
                            GtkIconInfo *icon_info = gtk_icon_theme_lookup_icon(theme, icon_value, 48, GTK_ICON_LOOKUP_FORCE_SIZE);
                            if (icon_info) {
                                pixbuf = gtk_icon_info_load_icon(icon_info, NULL);
                                g_object_unref(icon_info);
                                if (pixbuf) {
                                    g_print("Loaded icon from theme: %s\n", icon_value);
                                }
                            }
                        }
                    }
                    break;
                }
            }
            
            g_strfreev(lines);
            g_free(contents);
        }
        
        if (error) g_error_free(error);
        if (pixbuf) return pixbuf;
    }
    
    GFile *file = g_file_new_for_path(filepath);
    GFileInfo *info = g_file_query_info(file, "standard::icon", G_FILE_QUERY_INFO_NONE, NULL, NULL);
    GIcon *gicon = NULL;
    
    if (info) {
        gicon = g_file_info_get_icon(info);
    }
    
    if (gicon) {
        GtkIconTheme *theme = gtk_icon_theme_get_default();
        GtkIconInfo *icon_info = gtk_icon_theme_lookup_by_gicon(theme, gicon, 48, GTK_ICON_LOOKUP_FORCE_SIZE);
        if (icon_info) {
            pixbuf = gtk_icon_info_load_icon(icon_info, NULL);
            g_object_unref(icon_info);
        }
    }
    
    if (!pixbuf) {
        pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, TRUE, 8, 48, 48);
        gdk_pixbuf_fill(pixbuf, 0xFF0000FF);  // Red square
    }
    
    if (info) g_object_unref(info);
    g_object_unref(file);
    
    return pixbuf;
}

static void on_icon_clicked(GtkWidget *widget, GdkEventButton *event, gpointer user_data) {
    char *filepath = (char*)user_data;
    if (!filepath || event->button != 1) {
        return;
    }
    
    GFile *file = g_file_new_for_path(filepath);
    gchar *uri = g_file_get_uri(file);
    GError *error = NULL;
    gboolean launched = FALSE;
    
    if (!g_file_query_exists(file, NULL)) {
        g_free(uri);
        g_object_unref(file);
        return;
    }
    
    if (g_str_has_suffix(filepath, ".desktop")) {
        GDesktopAppInfo *app_info = g_desktop_app_info_new_from_filename(filepath);
        
        if (app_info) {
            GAppLaunchContext *context = g_app_launch_context_new();
            launched = g_app_info_launch(G_APP_INFO(app_info), NULL, context, &error);
            g_object_unref(context);
            g_object_unref(app_info);
        }
    }
    
    // For regular files, try various launch methods
    if (!launched) {
        launched = g_app_info_launch_default_for_uri(uri, NULL, &error);
    }
    
    if (!launched) {
        const char *argv[] = {"xdg-open", filepath, NULL};
        launched = g_spawn_async(NULL, (char**)argv, NULL, G_SPAWN_SEARCH_PATH, NULL, NULL, NULL, &error);
    }
    
    if (error) {
        g_error_free(error);
    }
    
    g_free(uri);
    g_object_unref(file);
}

static GtkWidget* create_icon_widget(const char *filepath) {
    GtkWidget *grid, *image, *label, *event_box;
    GdkPixbuf *pixbuf;
    char *basename;
    char *display_text;
    
    basename = g_path_get_basename(filepath);
    pixbuf = load_icon_for_file(filepath);
    
    // Truncate long names
    if (strlen(basename) > 15) {
        char *temp = g_strndup(basename, 12);
        display_text = g_strdup_printf("%s...", temp);
        g_free(temp);
    } else {
        display_text = g_strdup(basename);
    }
    
    grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 8);
    
    image = gtk_image_new_from_pixbuf(pixbuf);
    g_object_unref(pixbuf);
    
    label = gtk_label_new(display_text);
    gtk_label_set_line_wrap(GTK_LABEL(label), TRUE);
    gtk_label_set_max_width_chars(GTK_LABEL(label), 12);
    gtk_label_set_xalign(GTK_LABEL(label), 0.5);
    gtk_label_set_yalign(GTK_LABEL(label), 0.5);
    
    gtk_grid_attach(GTK_GRID(grid), image, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), label, 0, 1, 1, 1);
    
    // Wrap in event box to handle clicks
    event_box = gtk_event_box_new();
    gtk_container_add(GTK_CONTAINER(event_box), grid);
    
    g_signal_connect(event_box, "button-press-event", G_CALLBACK(on_icon_clicked), g_strdup(filepath));
    
    apply_css_styling(grid,
        "grid {"
            "background-color: transparent; "
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
    
    gtk_widget_set_size_request(event_box, 110, 100);
    
    g_free(basename);
    g_free(display_text);
    
    return event_box;
}

static void reload_grid_layout(void) {
    int total = g_list_length(all_icons);
    
    // Clear the grid
    GList *children = gtk_container_get_children(GTK_CONTAINER(icon_grid));
    for (GList *child = children; child != NULL; child = child->next) {
        gtk_container_remove(GTK_CONTAINER(icon_grid), GTK_WIDGET(child->data));
    }
    g_list_free(children);
    
    // Re-add icons with proper column/row positions
    for (int i = 0; i < total; i++) {
        int column = i / icons_per_column;
        int row = i % icons_per_column;
        
        GtkWidget *icon = GTK_WIDGET(g_list_nth_data(all_icons, i));
        gtk_grid_attach(icon_grid, icon, column, row, 1, 1);
    }
    
    gtk_widget_show_all(GTK_WIDGET(icon_grid));
}

static void add_icon(const char *filepath) {
    GtkWidget *icon = create_icon_widget(filepath);
    all_icons = g_list_append(all_icons, icon);
}

static void load_desktop_files(void) {
    const char *desktop_path;
    GDir *dir;
    const char *filename;
    GError *error = NULL;
    
    desktop_path = g_get_user_special_dir(G_USER_DIRECTORY_DESKTOP);
    if (!desktop_path) {
        g_warning("Could not find desktop directory");
        return;
    }
    
    dir = g_dir_open(desktop_path, 0, &error);
    if (!dir) {
        g_warning("Failed to open desktop directory: %s", error->message);
        g_error_free(error);
        return;
    }
    
    while ((filename = g_dir_read_name(dir))) {
        if (filename[0] != '.') {
            char *full_path = g_build_filename(desktop_path, filename, NULL);
            add_icon(full_path);
            g_free(full_path);
        }
    }
    
    g_dir_close(dir);
}

static void calculate_icons_per_column(GtkWidget *window) {
    GdkScreen *screen = gtk_widget_get_screen(window);
    int screen_height = gdk_screen_get_height(screen);
    
    int icon_height = 110;
    int available_height = screen_height - 40;
    
    icons_per_column = available_height / icon_height;
    if (icons_per_column < 1) icons_per_column = 1;
}

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window;
    GtkWidget *scrolled_window;
    
    // Create main window
    window = gtk_application_window_new(app);
    gtk_layer_init_for_window(GTK_WINDOW(window));
    gtk_layer_set_namespace(GTK_WINDOW(window), "desktop-icons");
    gtk_layer_set_layer(GTK_WINDOW(window), GTK_LAYER_SHELL_LAYER_BOTTOM);
    
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, TRUE);
    
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, 20);
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, 20);
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, 20);
    gtk_layer_set_margin(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, 20);
    
    calculate_icons_per_column(window);
    
    // Create a scrolled window to handle overflow
    scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    
    // Create grid for icons
    icon_grid = GTK_GRID(gtk_grid_new());
    gtk_grid_set_column_spacing(icon_grid, 20);
    gtk_grid_set_row_spacing(icon_grid, 15);
    
    load_desktop_files();
    reload_grid_layout();
    
    gtk_container_add(GTK_CONTAINER(scrolled_window), GTK_WIDGET(icon_grid));
    gtk_container_add(GTK_CONTAINER(window), scrolled_window);
    
    gtk_window_set_default_size(GTK_WINDOW(window), -1, -1);
    gtk_widget_set_size_request(window, -1, -1);
    
    apply_css_styling(window,
        "window {"
            "background-color: transparent;"
        "}"
        "window.background {"
            "background-color: transparent;"
        "}"
    );
    
    apply_css_styling(scrolled_window,
        "scrolledwindow {"
            "background-color: transparent;"
        "}"
        "scrolledwindow.viewport {"
            "background-color: transparent;"
        "}"
    );
    
    gtk_widget_show_all(window);
}

int main(int argc, char **argv) {
    GtkApplication *app;
    int status;
    
    app = gtk_application_new("com.example.dicons", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    
    status = g_application_run(G_APPLICATION(app), argc, argv);
    
    for (GList *l = all_icons; l != NULL; l = l->next) {
        gtk_widget_destroy(GTK_WIDGET(l->data));
    }
    g_list_free(all_icons);
    
    g_object_unref(app);
    
    return status;
}
