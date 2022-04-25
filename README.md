# Sillicon Power Inc.

La empresa **Sillicon Power Inc.**, cliente de **Doonamis**, desea tener una aplicación móvil que le permita ver las películas más populares.

# v1.0

- **Listado**: Desarrollar una aplicación que muestre un listado paginado con las películas más populares de TV.

- **Detalle**: Poder acceder al detalle de la serie, viendo toda su información. 

## Consideraciones

-   **Framework**: La app se puede desarrollar tanto en UIKit como en SwiftUI.
-   **Arquitectura**: Utilizar la arquitectura que mejor se adecue al framework utilizado.  
-   **UX/UI**: El diseño de la aplicación no está definido, así que hay total libertad menos por dos detalles.  
    - La aplicación solo puede soportar una orientación. 
    - No soporta DarkMode.

# v2.0

-   **Modo offline**: Una vez descargado el contenido, este debe poder verse sin conexión a internet.
-   **Multiidioma**: Mostrar al usuario alguna manera de poder escoger el idioma de la aplicación y que la información que se muestre de la API venga en ese idioma seleccionado que puede cambiar durante el uso de la aplicación.

## Consideraciones

-   **Offline**: Se puede usar tanto CoreData como Realm.
-   **UX/UI**:
    - La aplicación soporta orientación vertical y horizontal.
    - Soporta DarkMode (para esta última característica se tienen que ver claras dos paletas de colores)
