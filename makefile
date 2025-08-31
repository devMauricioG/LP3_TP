# Compilador y flags
CXX := g++
CC := gcc
CXXFLAGS := -Wall -std=c++17
CFLAGS := -Wall -std=c17 -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE

# Directorios
SRC_DIR := src
BIN_DIR := bin

# ======================
# Archivos a excluir (sin main() o con dependencias especiales)
# ======================
EXCLUDE_FILES := readfile.c temp_file.c tifftest.c condvar.c cleanup.c

# ======================
# Capítulos 3 y anteriores (ejecutables 1:1)
# ======================
EXECUTABLES_SINGLE := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(wildcard $(SRC_DIR)/capitulo3/*.c)) \
                      $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(filter-out $(addprefix $(SRC_DIR)/capitulo2/,$(EXCLUDE_FILES)),$(wildcard $(SRC_DIR)/capitulo2/*.c))) \
                      $(filter-out $(BIN_DIR)/capitulo1/main,$(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(wildcard $(SRC_DIR)/capitulo1/*.c)))

# ======================
# Capítulo 4 - solo primes.c tiene main()
# ======================
EXECUTABLES_CAP4 := $(BIN_DIR)/capitulo4/primes

# ======================
# Capítulo 5 - encontrar archivos con main()
# ======================
CAP5_SOURCES := $(wildcard $(SRC_DIR)/capitulo5/*.c)
define compile_cap5
for file in $(CAP5_SOURCES); do \
    if grep -q "main(" "$$file"; then \
        exe=$(BIN_DIR)/capitulo5/$$(basename $$file .c); \
        mkdir -p $$(dirname $$exe); \
        $(CC) $(CFLAGS) $$file -o $$exe; \
        echo "Compilado $$exe"; \
    fi; \
done
endef

.PHONY: cap5
cap5:
	@$(compile_cap5)	
EXECUTABLES_CAP5 := $(patsubst $(SRC_DIR)/%.c,$(BIN_DIR)/%,$(CAP5_WITH_MAIN))


# ======================
# Excluir test.c de la compilación individual (ya que se usa con app.c)
# ======================
EXECUTABLES_SINGLE := $(filter-out $(BIN_DIR)/capitulo2/test,$(EXECUTABLES_SINGLE))

# ======================
# Ejecutables totales
# ======================
EXECUTABLES := $(EXECUTABLES_SINGLE) $(EXECUTABLES_CAP4) $(EXECUTABLES_CAP5) $(BIN_DIR)/capitulo1/main

# ======================
# Regla por defecto
# ======================
all: $(EXECUTABLES)

# ======================
# Regla genérica para archivos C - usa gcc
# ======================
$(BIN_DIR)/%: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $< -o $@

# ======================
# Regla genérica para archivos C++ - usa g++
# ======================
$(BIN_DIR)/%: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $< -o $@

# ======================
# Regla específica para app.c - compila app.c + test.c juntos
# ======================
$(BIN_DIR)/capitulo2/app: src/capitulo2/app.c src/capitulo2/test.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $^ -o $@

# ======================
# Regla específica para main.c - compila main.c + reciprocal.cpp juntos (C + C++)
# ======================
$(BIN_DIR)/capitulo1/main: src/capitulo1/main.c src/capitulo1/reciprocal.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $^ -o $@

# ======================
# Limpieza
# ======================
clean:
	rm -rf $(BIN_DIR)/*

# ======================
# Verificar archivos con main() en capítulo 5
# ======================
check-main-cap5:
	@echo "=== Verificando archivos en capitulo5/ ==="
	@for file in src/capitulo5/*.c; do \
		if grep -l "main(" $$file >/dev/null; then \
			echo "✓ $$file (tiene main)"; \
		else \
			echo "✗ $$file (sin main)"; \
		fi; \
	done