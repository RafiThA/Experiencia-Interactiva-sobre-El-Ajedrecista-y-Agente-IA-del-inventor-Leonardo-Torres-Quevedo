#!/bin/bash

#==========================================================
#
# Script para instalar y actualizar el LLM de Leonardo Torres Quevedo.
#
# Rafael Molleja Jiménez - 2026.
#
#==========================================================

# COLORES
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'  # No Color

# FLAGS
UPDATE=false                # Actualiza el modelo usando un archivo de contexto.
INSTALL=false               # Instala el modelo desde cero con un archivo de contexto.
REMOVE=false                # Elimina el modelo de 'torresQuevedoLLM' de Ollama.
CLEAN=false                 # Elimina los modelos utilizados para crear el modelo de 'torresQuevedoLLM' para liberar espacio.
CONTEXT_FILE_NAME="NULL"    # Nombre del archivo de contexto a usar para actualizar o instalar el modelo.
IP_PORT="localhost:11434"   # IP y puerto para ejecutar el modelo.
# Funcion de ayuda.
usage() {
    echo "Uso: $0 [OPCIONES]"
    echo "Opciones:"
    echo "  --install [ContextFile]   Instalar el LLM con el archivo de contexto especificado"
    echo "  --update [ContextFile]    Actualizar el contexto del LLM con el archivo de contexto especificado"
    echo "  --remove                  Eliminar el LLM"
    echo "  --clean                   Eliminar modelos utilizados para crear el modelo de 'torresQuevedoLLM' para liberar espacio"
    echo "  --ip [IP:PORT]            Especificar la IP y puerto para ejecutar el modelo (por defecto: localhost:11434)"
    echo "  --help                    Mostrar esta ayuda"
}

# Argumentos admitidos.
while [[ $# -gt 0 ]]; do
    case $1 in
        --install)
            INSTALL=true

            # Obtenemos el nombre del archivo de contexto.
            if [[ -z "$2" ]]; then

                echo -e "${RED}❌ Error: El argumento '--install' requiere un nombre de archivo${NC}"
                usage
                exit 1
            fi

            CONTEXT_FILE_NAME="$2"

            shift 2

            ;;

        --update)
            UPDATE=true

            # Obtenemos el nombre del archivo de contexto.
            if [[ -z "$2" ]]; then

                echo -e "${RED}❌ Error: El argumento '--update' requiere un nombre de archivo${NC}"
                usage
                exit 1
            fi

            CONTEXT_FILE_NAME="$2"

            shift 2

            ;;

        --ip)

            if [[ -z "$2" ]]; then

                echo -e "${RED}❌ Error: El argumento '--ip' requiere una dirección IP y puerto${NC}"
                usage
                exit 1
            fi

            IP_PORT="$2"

            shift 2

            ;;

        --remove)
            REMOVE=true

            shift

            ;;
        
        --clean)
            CLEAN=true
            shift
            ;;

        --help)
            usage
            exit 0
            ;;

        *)
            echo "Opción desconocida: $1"
            usage
            exit 1
            ;;
    esac
done

# PASO 1: Actualizar sistema y verificar que ollama este instalado.

# Solo actualizar el sistema si es install o update, no para remove o clean.
if [ "$INSTALL" = true ] || [ "$UPDATE" = true ]; then

    # Actualizar sistema.

    echo -e "${BLUE}🔄 Actualizando el sistema...${NC}"

    if sudo apt-get update && sudo apt-get upgrade; then

        echo -e "${GREEN}✅ Sistema actualizado correctamente${NC}"

    else

        echo -e "${RED}❌ Error actualizando el sistema${NC}"
        exit 1
    fi

fi


# Instalar ollama si no lo esta.
if command -v ollama &> /dev/null; then

    echo -e "${GREEN}✅ Ollama está instalado${NC}"

else
    echo -e "${RED}❌ Ollama no está instalado${NC}"

    echo ""

    echo "📦 Instalando Ollama..."

    if curl -fsSL https://ollama.com/install.sh | sh; then

        echo -e "${GREEN}✅ Ollama instalado correctamente${NC}"

    else

        echo -e "${RED}❌ Error instalando Ollama${NC}"
        exit 1
    fi

    exit 1
fi

# Especificar IP y Puerto.
if ! [ "$IP_PORT" = "localhost:11434" ]; then

    export OLLAMA_HOST="http://$IP_PORT"
    echo -e "${GREEN}✅ Usando servidor Ollama en: $OLLAMA_HOST${NC}"

fi

# PASO 2: Comporbar que el modelo de torresQuevedoLLM existe.

# Comprueba si el modelo de torresQuevedoLLM existe.
if ollama list | grep -q "torresQuevedoLLM"; then

    echo -e "${GREEN}✅ Modelo 'torresQuevedoLLM' ya existe${NC}"

    MODEL_EXISTS=true

else

    MODEL_EXISTS=false   

    echo -e "${BLUE}ℹ️ El modelo 'torresQuevedoLLM' no existe.${NC}"    
fi

# PASO 3: Instalar modelo si se ha especificado la opción --install.

if [ "$INSTALL" = true ]; then

    echo "📦 Instalando el modelo 'torresQuevedoLLM' con el archivo de contexto '$CONTEXT_FILE_NAME'..."

    if ollama create torresQuevedoLLM -f "$CONTEXT_FILE_NAME"; then

        echo -e "${GREEN}✅ Modelo 'torresQuevedoLLM' instalado correctamente${NC}"

    else

        echo -e "${RED}❌ Error instalando el modelo 'torresQuevedoLLM'${NC}"
        exit 1
    fi
fi


# PASO 4: Actualizar modelo si se ha especificado la opción --update.

if [ "$UPDATE" = true ]; then

    echo "🔄 Actualizando el modelo 'torresQuevedoLLM' con el archivo de contexto '$CONTEXT_FILE_NAME'..."

    # Ver si existe el modelo.
    if [ "$MODEL_EXISTS" = true ]; then

        if ollama rm torresQuevedoLLM && ollama create torresQuevedoLLM -f "$CONTEXT_FILE_NAME"; then

            echo -e "${GREEN}✅ Modelo 'torresQuevedoLLM' actualizado correctamente${NC}"

        else

            echo -e "${RED}❌ Error actualizando el modelo 'torresQuevedoLLM'${NC}"
            exit 1
        fi

    else

        echo -e "${RED}❌ El modelo 'torresQuevedoLLM' no existe. No se puede actualizar. Instala el modelo primero con la opcion '--install'${NC}"
    fi
fi


# PASO 5: Eliminar modelo si se ha especificado la opción --remove.

if [ "$REMOVE" = true ]; then

    # Elimina el modelo solo si existe.
    if [ "$MODEL_EXISTS" = true ]; then

        echo "🔄 Eliminando el modelo 'torresQuevedoLLM'..."

        if ollama rm torresQuevedoLLM; then

            echo -e "${GREEN}✅ Modelo 'torresQuevedoLLM' eliminado correctamente${NC}"

        else

            echo -e "${RED}❌ Error eliminando el modelo 'torresQuevedoLLM'${NC}"
            exit 1
        fi
    fi
fi

# PASO ADICIONAL: Eliminar modelos utilizados para crear el modelo de 'torresQuevedoLLM' para liberar espacio si se ha especificado la opción --clean.

if [ "$CLEAN" = true ]; then

    echo -e "🔄 Eliminando todos los modelos excepto 'torresQuevedoLLM'..."
    
    # Obtener lista de modelos y eliminar los que no sean torresQuevedoLLM
    ollama list | tail -n +2 | awk '{print $1}' | while read model; do

        model_name="${model%:*}"

        if [ "$model_name" != "torresQuevedoLLM" ]; then

            echo -e "  ${BLUE}ℹ️Eliminando: $model${NC}"

            if ! ollama rm "$model"; then

                echo -e "${RED}  ❌ Error eliminando '$model'${NC}"
            fi
        fi
    done
    
    echo -e "${GREEN}✅ Limpieza completada${NC}"
fi

echo ""
echo -e "${GREEN}✅ Tareas finalizadas correctamente${NC}"