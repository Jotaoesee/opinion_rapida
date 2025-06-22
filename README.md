📊 Opinion Rápida: Tu Plataforma de Encuestas en Tiempo Real 🚀
Descripción del Proyecto
Esta aplicación innovadora, desarrollada con Flutter y Firebase Firestore, te permite crear, participar y visualizar los resultados de encuestas en tiempo real de una manera sencilla y eficiente. Olvídate de los largos procesos de recolección de feedback; con Opinion Rápida, obtener y dar tu opinión nunca fue tan ágil.

Ya sea que necesites tomar una decisión grupal, recopilar el sentir de una audiencia o simplemente conocer las preferencias de tus amigos, Opinion Rápida es la herramienta perfecta. Proporciona una interfaz intuitiva para generar encuestas con hasta cuatro opciones y visualizar cómo evoluciona la votación al instante.

El Problema que Resuelve
En la era digital, la agilidad en la toma de decisiones y la recolección de feedback son cruciales. Opinion Rápida aborda la necesidad de:

Recopilar feedback instantáneo: Elimina la barrera de tiempo y complejidad en la creación y respuesta de encuestas.

Facilitar la toma de decisiones grupales: Permite a equipos, comunidades o grupos de amigos votar rápidamente sobre opciones y ver los resultados consolidarse en tiempo real.

Ofrecer una plataforma de votación accesible: Con una interfaz limpia y simple, cualquier persona puede usarla sin curva de aprendizaje.

¿Para Quién es Útil?
Opinion Rápida es una solución ideal para:

Equipos de trabajo: Para decisiones rápidas sobre proyectos, preferencias o planes.

Educadores: Para encuestas rápidas en el aula o para conocer la opinión de los estudiantes.

Organizaciones y comunidades: Para votaciones informales o para medir el pulso de los miembros.

Grupos de amigos y familias: Para decidir planes, elecciones de películas, comidas, etc.

Desarrolladores de Flutter: Como un excelente ejemplo de aplicación CRUD (Crear, Leer, Actualizar) con Firebase Firestore, manejo de estado y persistencia local (SharedPreferences).

✨ Características Destacadas
➕ Creación de Encuestas Intuitiva: Define un título, tu nombre como creador, y hasta 4 opciones de encuesta de forma rápida y sencilla.

📋 Listado Dinámico de Encuestas: Visualiza todas las encuestas disponibles, actualizadas en tiempo real desde la nube.

🔍 Búsqueda y Filtrado: Encuentra encuestas fácilmente filtrando por el nombre del creador o por el título de la encuesta.

🗳️ Votación Simplificada: Selecciona tu opción preferida y emite tu voto con un solo toque.

📈 Resultados en Tiempo Real: Observa cómo los porcentajes y conteos de votos se actualizan instantáneamente a medida que la gente participa.

🔒 Prevención de Votos Duplicados: Utiliza persistencia local para asegurar que cada usuario solo pueda votar una vez por encuesta.

☁️ Almacenamiento en la Nube: Todas las encuestas y votos se almacenan de forma segura en Firebase Firestore, garantizando accesibilidad y escalabilidad.

🎨 Diseño Moderno y Responsivo: Una interfaz de usuario limpia y agradable, diseñada para una experiencia óptima en cualquier dispositivo móvil.

🛠️ Tecnologías Utilizadas
Lenguaje de Programación: Dart

Framework de Desarrollo: Flutter

Base de Datos NoSQL en la Nube: Firebase Firestore

Persistencia de Datos Local: shared_preferences

Herramientas de Desarrollo:

cloud_firestore

firebase_core

flutter/material.dart

flutter/foundation.dart

🚀 Cómo Instalar y Ejecutar
Para poner en marcha Opinion Rápida en tu entorno de desarrollo local, sigue estos pasos:

Prerrequisitos
Flutter SDK: Se recomienda utilizar la última versión estable.

Un editor de código (como VS Code con la extensión de Flutter) o un IDE (como Android Studio).

Un dispositivo o emulador configurado para ejecutar aplicaciones Flutter (Android, iOS, web o escritorio).

Una cuenta de Firebase y un proyecto de Firebase configurado.

Configuración de Firebase
Crea un Proyecto en Firebase: Ve a la Consola de Firebase y crea un nuevo proyecto.

Agrega Flutter a tu Proyecto Firebase: Sigue las instrucciones oficiales de Flutter para agregar Firebase a tu aplicación Flutter. Esto incluye instalar la CLI de Firebase, inicializar Firebase en tu proyecto Flutter y configurar los archivos específicos para Android (google-services.json) e iOS (GoogleService-Info.plist).

Habilita Firestore: En la consola de Firebase de tu proyecto, ve a "Firestore Database" y crea una nueva base de datos en modo de producción (o de prueba si solo estás experimentando). Asegúrate de configurar las reglas de seguridad de Firestore para permitir la lectura y escritura adecuada (por ejemplo, permitir leer/escribir si el usuario está autenticado, aunque esta aplicación de ejemplo no tiene autenticación, podrías necesitar ajustar esto para producción).

Ejemplo básico de reglas (solo para desarrollo, ¡no usar en producción sin un control de seguridad adecuado!):

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /encuestas/{document=**} {
      allow read, write: if true; // Permite a cualquiera leer y escribir
    }
  }
}

(¡Advertencia! La regla allow read, write: if true; hace tu base de datos pública. Para una aplicación real, implementa autenticación y reglas de seguridad más restrictivas.)

Pasos de Instalación de la Aplicación
Clona el repositorio:

git clone https://github.com/tu_usuario/opinion_rapida.git
cd opinion_rapida

(Nota: Reemplaza https://github.com/tu_usuario/opinion_rapida.git con la URL real de tu repositorio si es diferente).

Instala las dependencias de Flutter:

flutter pub get

Esto descargará todas las librerías y paquetes definidos en pubspec.yaml, incluyendo Firebase Firestore y shared_preferences.

Cómo Ejecutar la Aplicación
Una vez que los pasos de configuración de Firebase y de instalación de la aplicación se hayan completado, puedes iniciar la aplicación:

Ejecuta la aplicación:

flutter run

La aplicación se lanzará en el dispositivo o emulador que tengas configurado. Si tienes varios, puedes seleccionar uno con flutter run -d <device_id>.

📈 Cómo Usar la Aplicación
Opinion Rápida está diseñada para ser intuitiva y fácil de usar, permitiéndote crear y votar en encuestas en pocos pasos.

🏠 Pantalla de Inicio (InicioEncuesta)
Al abrir la aplicación, serás recibido por la pantalla de inicio con dos botones principales:

"Crear Encuesta": Te lleva a la pantalla donde puedes diseñar una nueva encuesta.

"Ver Encuestas": Te dirige a la lista de encuestas existentes para que puedas explorarlas y votar.

➕ Crear una Encuesta (CrearEncuesta)
Haz clic en "Crear Encuesta" desde la pantalla de inicio.

Tu nombre: Introduce el nombre del creador de la encuesta.

Título de la encuesta: Escribe la pregunta o el tema de tu encuesta.

Opciones separadas por coma (4 opciones): Ingresa las cuatro opciones para tu encuesta, separándolas con comas.

Ejemplo: Opción A, Opción B, Opción C, Opción D

Haz clic en "Crear Encuesta". La aplicación validará que todos los campos estén completos y que tengas exactamente 4 opciones. Si todo es correcto, tu encuesta se guardará en Firestore y serás redirigido a la lista de encuestas.

📄 Ver Encuestas (ListaEncuesta)
Desde la pantalla de inicio, haz clic en "Ver Encuestas".

Verás una lista de todas las encuestas disponibles.

Filtrar Encuestas: Utiliza los campos de texto en la parte superior para buscar encuestas:

"Filtrar por nombre del creador": Escribe el nombre del creador para ver sus encuestas.

"Filtrar por título": Escribe parte del título de la encuesta para encontrarla.

Los resultados se actualizarán en tiempo real a medida que escribas.

Seleccionar una Encuesta: Haz clic en cualquier encuesta de la lista para ver sus detalles y votar.

✅ Votar en una Encuesta (PantallaVotacion)
Al seleccionar una encuesta de la lista, accederás a la Pantalla de Votación.

Verás el título de la encuesta y la lista de sus cuatro opciones.

Junto a cada opción, podrás ver los votos actuales y el porcentaje que representa del total. ¡Estos resultados se actualizan en tiempo real!

Emitir tu voto: Selecciona una de las opciones haciendo clic en el círculo de radio.

Haz clic en el botón "Guardar Voto" en la parte inferior.

Una vez que hayas votado, las opciones de radio y el botón "Guardar Voto" se deshabilitarán para evitar votos duplicados desde tu dispositivo.

Podrás seguir viendo los resultados actualizados, incluso después de votar.
