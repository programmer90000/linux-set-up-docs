#include <gtk/gtk.h>
#include <gtk-layer-shell/gtk-layer-shell.h>

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window;
    GtkCssProvider *provider;
    GdkDisplay *display;
    
    window = gtk_application_window_new(app);
    
    gtk_layer_init_for_window(GTK_WINDOW(window));
    gtk_layer_set_namespace(GTK_WINDOW(window), "desktop-icons");
    gtk_layer_set_layer(GTK_WINDOW(window), GTK_LAYER_SHELL_LAYER_BOTTOM);
    
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, TRUE);
    
    provider = gtk_css_provider_new();
    gtk_css_provider_load_from_data(provider,
        "window {"
            "background-color: transparent;"
        "}"
        ".background {"
            "background-color: transparent;"
        "}",
        -1, NULL);
    
    display = gdk_display_get_default();
    gtk_style_context_add_provider_for_screen(gdk_display_get_default_screen(display), GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    
    g_object_unref(provider);
    
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
