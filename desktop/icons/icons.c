#include <gtk/gtk.h>
#include <gtk-layer-shell/gtk-layer-shell.h>

static void apply_css_styling(GtkWidget *widget, const char *css) {
    GtkStyleContext *context = gtk_widget_get_style_context(widget);
    GtkCssProvider *provider = gtk_css_provider_new();
    
    gtk_css_provider_load_from_data(provider, css, -1, NULL);
    gtk_style_context_add_provider(context, GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    g_object_unref(provider);
}

static void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window, *flowbox, *grid, *image, *label;
    GdkPixbuf *pixbuf;
    
    window = gtk_application_window_new(app);
    
    gtk_layer_init_for_window(GTK_WINDOW(window));
    gtk_layer_set_namespace(GTK_WINDOW(window), "desktop-icons");
    gtk_layer_set_layer(GTK_WINDOW(window), GTK_LAYER_SHELL_LAYER_BOTTOM);
    
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_LEFT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_TOP, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_RIGHT, TRUE);
    gtk_layer_set_anchor(GTK_WINDOW(window), GTK_LAYER_SHELL_EDGE_BOTTOM, TRUE);
    
    flowbox = gtk_flow_box_new();
    gtk_flow_box_set_max_children_per_line(GTK_FLOW_BOX(flowbox), 4);
    gtk_flow_box_set_homogeneous(GTK_FLOW_BOX(flowbox), TRUE);
    gtk_flow_box_set_column_spacing(GTK_FLOW_BOX(flowbox), 20);
    gtk_flow_box_set_row_spacing(GTK_FLOW_BOX(flowbox), 20);
    
    grid = gtk_grid_new();
    gtk_grid_set_row_spacing(GTK_GRID(grid), 8);
    
    pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, TRUE, 8, 48, 48);
    gdk_pixbuf_fill(pixbuf, 0x4287f5FF);
    image = gtk_image_new_from_pixbuf(pixbuf);
    g_object_unref(pixbuf);
    
    label = gtk_label_new("Test App");
    gtk_label_set_line_wrap(GTK_LABEL(label), TRUE);
    gtk_label_set_max_width_chars(GTK_LABEL(label), 12);
    gtk_label_set_xalign(GTK_LABEL(label), 0.5);
    gtk_label_set_yalign(GTK_LABEL(label), 0.5);
    
    gtk_grid_attach(GTK_GRID(grid), image, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), label, 0, 1, 1, 1);
    
    gtk_container_add(GTK_CONTAINER(flowbox), grid);
    gtk_container_add(GTK_CONTAINER(window), flowbox);
    
    apply_css_styling(window,
        "window {"
            "background-color: transparent;"
        "}"
        "window.background { background-color: transparent; }"
    );
    
    apply_css_styling(flowbox,
        "flowbox {"
            "background-color: transparent;"
        "}"
        "flowboxchild {"
            "background-color: transparent;"
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
    
    apply_css_styling(grid,
        "grid {"
            "background-color: transparent;"
        "}"
        "grid:hover {"
            "background-color: rgba(255, 255, 255, 0.1);"
            "border-radius: 5px;"
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
