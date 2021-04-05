IOSEVKA_SRC=./Iosevka
IOSEVKA_DIST=./Iosevka/dist
NERD_FONTS=./nerd-fonts
PATCHED_DIR=./patched
PATCH_INCLUDE=--complete
BUILD_NAME=iosevka-custom
BUILD_TYPE=ttf
# BUILD_TYPE=ttf-unhinted

all: iosevka-install iosevka-build patch

iosevka-install:
	npm install --prefix $(IOSEVKA_SRC)

iosevka-build: iosevka-install
	cp ./private-build-plans.toml $(IOSEVKA_SRC)
	npm run build --prefix $(IOSEVKA_SRC) -- $(BUILD_TYPE)::$(BUILD_NAME)

$(IOSEVKA_DIST)/$(BUILD_NAME)/$(BUILD_TYPE)/*.ttf : iosevka

patch: $(IOSEVKA_DIST)/$(BUILD_NAME)/$(BUILD_TYPE)/*.ttf
	for file in $^ ; do \
		fontforge --script $(NERD_FONTS)/font-patcher $(PATCH_INCLUDE) --careful $$file -out $(PATCHED_DIR) ; \
	done

clean:
	rm -rf $(IOSEVKA_DIST)
	rm -rf $(PATCHED_DIR)
