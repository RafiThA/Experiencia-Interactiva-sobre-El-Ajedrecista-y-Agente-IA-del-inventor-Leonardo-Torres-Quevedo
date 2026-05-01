# TFG - Contenidos del Agente LLM

## Información

Se proporciona un script `torresQuevedoLLMScript.sh` el cual permite instalar, actualizar y borrar el modelo con un contexto personalizado.

Si no se indica ningún argumento el script solo comprueba que el modelo existe. Para ver la lista de argumentos disponibles ejecutar: 

```shell
./torresQuevedoLLMScript.sh --help
```

## Instalación del Modelo

Para instalar el modelo LLM de Leonardo Torres Quevedo ejecutar:

```shell
./torresQuevedoLLMScript.sh --install leonardo_torres_quevedo_system_context.mf
```

Para una instalación limpia (elimina los demas modelos creados durante la instalación excepto `torresQuevedoLLM`) ejecutar:

```shell
./torresQuevedoLLMScript.sh --clean --install leonardo_torres_quevedo_system_context.mf
```

## Actualizar Modelo

Para actualizar el contexto del modelo ejecutar:

```shell
./torresQuevedoLLMScript.sh --update leonardo_torres_quevedo_system_context.mf
```

## Probar Conexión con el Modelo

Para probar que el modelo está correctamente instalado y está preparado para contestar se proporciona el script `testModel.sh`.

> [!NOTE]
> Por defecto se utiliza el endpoint `http://localhost:11434/api/chat` y el nombre de modelo `torresQuevedoLLM`.


### Enviar Prompt al Modelo

Para enviar un prompt al modelo usando el script deberemos ejecutar:

```shell
./testModel.sh 'mensaje a enviar entre comillas simples'
```

### Iniciar una Conversación con el Modelo

Para iniciar un chat con el modelo en la terminal ejecutar:

```shell
./testModel.sh --chat
```

Existen otros parametros para configurar el nombre del modelo o el endpoint de la solicitud, para ver las opciones disponibles se puede ejecutar:

```shell
./testModel.sh --help
```

## Autor

Rafael Molleja Jiménez 2026
