# TFG - Experiencia Interactiva sobre "El Ajedrecista" y Agente IA del inventor Leonardo Torres Quevedo

## Información

Se proporciona un script llamado `torresQuevedoLLMScript.sh`, que permite instalar, actualizar y eliminar el modelo con un contexto personalizado.

> [!NOTA]
> Por defecto, el contexto del modelo se denomina `leonardo_torres_quevedo_system_context.mf`. Este archivo especifica cómo debe comportarse el modelo, qué parámetros utiliza y en qué modelo se basa.

Si no se especifican argumentos, el script simplemente comprueba si el modelo existe. Para ver la lista de argumentos disponibles, ejecuta: 

```shell
./torresQuevedoLLMScript.sh --help
```

## Instalación del modelo

Para instalar el modelo LLM de Leonardo Torres Quevedo, ejecuta:

```shell
./torresQuevedoLLMScript.sh --install leonardo_torres_quevedo_system_context.mf
```

Para realizar una instalación limpia (que elimina todos los demás modelos creados durante la instalación, excepto `torresQuevedoLLM`), ejecuta:

```shell
./torresQuevedoLLMScript.sh --clean --install leonardo_torres_quevedo_system_context.mf
```

## Actualizar el modelo

Para actualizar el contexto del modelo, ejecuta:

```shell
./torresQuevedoLLMScript.sh --update leonardo_torres_quevedo_system_context.mf
```

## Test Connection to the Model

To verify that the model is correctly installed and ready to respond, use the `testModel.sh` script.

> [!NOTA]
> Por defecto, se utilizan el punto final `http://localhost:11434/api/chat` y el nombre del modelo `torresQuevedoLLM`.

## Asignar dirección IP y puerto

Para ejecutar el modelo en una dirección IP y un puerto distintos de `localhost:11434` (la configuración por defecto), puedes utilizar el parámetro `--ip [IP:PORT]`, tal y como se muestra a continuación:

```shell
./testModel.sh '--ip 192.168.1.1:11434'
```


### Envío de una solicitud al modelo

Para enviar una solicitud al modelo mediante el script, ejecuta:

```shell
./testModel.sh 'mensaje a enviar entre comillas simples'
```

### Iniciar una conversación con el modelo

Para iniciar un chat con el modelo en la terminal, ejecuta:

```shell
./testModel.sh --chat
```

Existen otros parámetros para configurar el nombre del modelo o el punto final de la solicitud. Para ver las opciones disponibles, ejecuta:

```shell
./testModel.sh --help
```

## Pruebas del agente

Se han realizado algunas pruebas para verificar cómo responde el modelo al contexto proporcionado:

### Hola, ¿quién eres?

Soy Leonardo Torres Quevedo, ingeniero español y pionero en la automática. Estimado visitante, bienvenido a mi laboratorio donde he desarrollado esta maravilla mecánica conocida como El Ajedrecista.

### Cuéntame cómo funciona tu invento, el ajedrecista.

Señor, mi Ajedrecista es una máquina diseñada para jugar al ajedrez en un final específico con su Rey y Torre blancas contra mi Rey negro. Utiliza relés y electroimanes para tomar decisiones basadas en la posición del tablero, garantizando siempre el mate dentro de menos de cincuenta movimientos. Le invito a que lo experimente personalmente aquí mismo.

### ¿Cómo funciona el invento?

Señor invitado, mi Ajedrecista opera mediante un sistema de sensores y actuadores electrónicos. Al colocar su rey negro en el tablero, los contactos eléctricos bajo las casillas detectan la posición del adversario, permitiendo a la máquina tomar decisiones lógicas sobre cómo mover mi torre blanca para asegurar el mate en menos de cincuenta movimientos.

## Autor

Rafael Molleja Jiménez - 2026
