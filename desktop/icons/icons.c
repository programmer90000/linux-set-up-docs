#include <gtk/gtk.h>
#include <gtk-layer-shell/gtk-layer-shell.h>
#include <gio/gio.h>

static GtkBox *icon_box = NULL;

static void apply_css_styling(GtkWidget *widget, const char *css) {
    GtkStyleContext *context = gtk_widget_get_style_context(widget);
    GtkCssProvider *provider = gtk_css_provider_new();
    
    gtk_css_provider_load_from_data(provider, css, -1, NULL);
    gtk_style_context_add_provider(context, GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    g_object_unref(provider);
}

static GdkPixbuf* load_icon_for_file(const char *filepath) {
    GdkPixbuf *pixbuf = NULL;
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

static void add_icon_for_file(GtkBox *box, const char *filepath) {
    GtkWidget *grid, *image, *label;
    GdkPixbuf *pixbuf;
    char *display_name;
    char *basename;
    
    basename = g_path_get_basename(filepath);
    display_name = basename;
    pixbuf = load_icon_for_file(filepath);
    
    grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 8);
    
    gtk_widget_set_size_request(grid, 100, -1);
    
    image = gtk_image_new_from_pixbuf(pixbuf);
    g_object_unref(pixbuf);
    
    label = gtk_label_new(display_name);
    gtk_label_set_line_wrap(GTK_LABEL(label), TRUE);
    gtk_label_set_max_width_chars(GTK_LABEL(label), 10);
    gtk_label_set_xalign(GTK_LABEL(label), 0.5);
    gtk_label_set_yalign(GTK_LABEL(label), 0.5);
    
    gtk_grid_attach(GTK_GRID(grid), image, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), label, 0, 1, 1, 1);
    
    g_object_set_data_full(G_OBJECT(grid), "filepath", g_strdup(filepath), g_free);
    
    apply_css_styling(grid,
        "grid {"
            "background-color: rgba(0, 100, 200, 0.3);"
            "border: 1px solid blue;"
            "padding: 5px;"
            "margin: 5px;"
        "}"
        "grid:hover {"
            "background-color: rgba(0, 100, 200, 0.6);"
        "}"
    );
    
    apply_css_styling(label,
        "label {"
            "color: white;"
            "text-shadow: 1px 1px 2px black;"
            "font-size: 12px;"
            "font-weight: bold;"
        "}"
    );
    
    gtk_box_pack_start(box, grid, FALSE, FALSE, 0);
    
    g_free(basename);
}

static void load_desktop_files(GtkBox *box) {
    const char *desktop_path;
    GDir *dir;
    const char *filename;
    GError *error = NULL;
    
    desktop_path = g_get_user_special_dir(G_USER_DIRECTORY_DESKTOP);
    if (!desktop_path) {
        g_warning("Could not find desktop directory");
        return;
    }
    
    g_print("Loading desktop files from: %s\n", desktop_path);
    
    dir = g_dir_open(desktop_path, 0, &error);
    if (!dir) {
        g_warning("Failed to open desktop directory: %s", error->message);
        g_error_free(error);
        return;
    }
    
    while ((filename = g_dir_read_name(dir))) {
        char *full_path = g_build_filename(desktop_path, filename, NULL);
        
        // Skip hidden files
        if (filename[0] != '.') {
            add_icon_for_file(box, full_path);
        }
        
        g_free(full_path);
    }
    
    g_dir_close(dir);
    
    GList *children = gtk_container_get_children(GTK_CONTAINER(box));
    g_print("Added %d icons to desktop\n", g_list_length(children));
    g_list_free(children);
}

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window;
    GtkWidget *scrolled_window;
    GtkWidget *viewport;
    
    // Create main window
    window = gtk_application_window_new(app);
    gtk_layer_init_for_window(GTK_WINDOW(window));
    gtk_layer_set_namespace(GTK_WINDOW(window), "desktop-icons");
    gtk_layer_set_layer(GTK_WINDOW(window), GTK_LAYER_SHELL_LAYER_BOTTOM);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, TRUE);
    
    // Create a scrolled window to handle overflow
    scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window), GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC);
    
    // Create a viewport to hold the box
    viewport = gtk_viewport_new(NULL, NULL);
    gtk_viewport_set_shadow_type(GTK_VIEWPORT(viewport), GTK_SHADOW_NONE);
    
    // Create a vertical box to hold icons
    icon_box = GTK_BOX(gtk_box_new(GTK_ORIENTATION_VERTICAL, 15));
    
    load_desktop_files(icon_box);
    
    gtk_container_add(GTK_CONTAINER(viewport), GTK_WIDGET(icon_box));
    gtk_container_add(GTK_CONTAINER(scrolled_window), viewport);
    gtk_container_add(GTK_CONTAINER(window), scrolled_window);
    
    gtk_window_set_default_size(GTK_WINDOW(window), 140, -1);
    
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
    );
    
    apply_css_styling(viewport,
        "viewport {"
            "background-color: transparent;"
        "}"
    );
    
    // Debug: Give the vertical box a visible background
    apply_css_styling(GTK_WIDGET(icon_box),
        "box {"
            "background-color: rgba(255, 0, 0, 0.2);"
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
    g_object_unref(app);
    
    return status;
}
