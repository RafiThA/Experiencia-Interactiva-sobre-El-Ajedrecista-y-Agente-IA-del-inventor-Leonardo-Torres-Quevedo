#!/bin/bash

#==========================================================
#
# Script para probar la conexion y probar el modelo.
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

# Variables
MODEL_NAME="torresQuevedoLLM"  # Nombre del modelo a probar.
API_URL="http://localhost:11434/api/chat"  # URL de la API de Ollama.
TIMEOUT=120  # Timeout en segundos
PROMPT=""
CHAT_MODE=false

# Función de ayuda
usage() {
    echo "Uso: $0 [OPCIONES] [PROMPT]"
    echo ""
    echo "Opciones:"
    echo "  --model [NOMBRE]         Nombre del modelo (default: torresQuevedoLLM)"
    echo "  --api-endpoint [URL]     URL de la API (default: http://localhost:11434/api/generate)"
    echo "  --timeout [SEGUNDOS]     Timeout de espera (default: 120)"
    echo "  --chat                   Habilita modo chat"
    echo "  --help                   Mostrar esta ayuda"
    echo ""
    echo "Ejemplo:"
    echo "  $0 'Cuéntame sobre Torres Quevedo'"
}

# Argumentos admitidos.
while [[ $# -gt 0 ]]; do
    case $1 in

        --api-endpoint)

            # Obtenemos el nuevo endpoint.
            if [[ -z "$2" ]]; then

                echo -e "${RED}❌ Error: El argumento '--api-endpoint' requiere un URL válido${NC}"
                usage
                exit 1
            fi

            API_URL="$2"
            shift 2
            ;;
        
        --model)

            # Obtenemos el nombre del modelo.
            if [[ -z "$2" ]]; then

                echo -e "${RED}❌ Error: El argumento '--model' requiere un nombre de modelo válido${NC}"
                usage
                exit 1
            fi

            MODEL_NAME="$2"
            shift 2
            ;;

        --timeout)
            if [[ -z "$2" ]]; then
                echo -e "${RED}❌ Error: --timeout requiere un número${NC}"
                usage
                exit 1
            fi

            TIMEOUT="$2"

            # Debe ser positivo > 0
            if ! [[ "$TIMEOUT" =~ ^[0-9]+$ ]] || [[ "$TIMEOUT" -lt 1 ]]; then
                echo -e "${RED}❌ Error: --timeout debe ser un numero entero mayor que 0${NC}"
                usage
                exit 1
            fi

            shift 2
            ;;

        --chat)
            CHAT_MODE=true
            shift
            ;;

        --help)
            usage
            exit 0
            ;;

        *)
            PROMPT="$1"
            shift
            ;;
    esac
done

# Comprobar que el modelo existe en Ollama.
if ! ollama list | grep -q "$MODEL_NAME"; then

    echo -e "${RED}❌ Error: El modelo '$MODEL_NAME' no existe en Ollama${NC}"
    exit 1
fi

if [ "$CHAT_MODE" = true ]; then

    echo "=========================================="
    echo -e "${BLUE}Iniciando modo chat...${NC}"
    echo -e "${MAGENTA}Modelo: $MODEL_NAME${NC}"
    echo -e "${MAGENTA}API Endpoint: $API_URL${NC}"
    echo "=========================================="
    echo ""

    if ! ollama run "$MODEL_NAME"; then

        echo -e "${RED}❌ Error: No se pudo iniciar el modo chat${NC}"
        exit 1
    fi

    echo ""
    echo -e "${BLUE} Script finalizado${NC}"
    exit 0

else

    # Verificar que el prompt se especificó
    if [[ -z "$PROMPT" ]]; then

        echo -e "${RED}❌ Error: No se especificó prompt${NC}"
        usage
        exit 1
    fi

    echo "=========================================="
    echo -e "${BLUE}Enviando prompt al modelo...${NC}"
    echo -e "${MAGENTA}Modelo: $MODEL_NAME${NC}"
    echo -e "${MAGENTA}API Endpoint: $API_URL${NC}"
    echo -e "${CYAN}Prompt: $PROMPT${NC}"
    echo "=========================================="
    echo ""

    echo -e "${YELLOW}⏳ Esperando respuesta (timeout: ${TIMEOUT}s)...${NC}"
    echo ""

    # Enviar POST con timeout
    if ! curl -s --max-time "$TIMEOUT" -X POST "$API_URL" \
    -H "Content-Type: application/json" \
    -d "{
        \"model\": \"$MODEL_NAME\",
        \"prompt\": \"$PROMPT\",
        \"stream\": false
    }" | jq -r '.response'; then

        echo -e "${RED}❌ Error: Timeout o error en la respuesta (${TIMEOUT}s)${NC}"
        exit 1
    fi

fi

echo ""
echo -e "${BLUE} Script finalizado${NC}"
exit 0
