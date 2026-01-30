# go framework

# api setup
mkdir sdp-admin-api
cd sdp-admin-api
go mod init sdp-admin-api
cp -r ../sdp-example-api/generation-scripts .
# replace in go mod
```
replace goframework/logger => ../../goframework/logger

replace goframework/server => ../../goframework/server

replace goframework/code-gen => ../../goframework/code-gen

replace goframework/gorm => ../../goframework/gorm

replace goframework/i18n => ../../goframework/i18n
```

go mod tidy
cp ../sdp-example-api/readme.md .

<!-- generate models -->
go run -tags generate generation-scripts/generate_db_models_admin.go --db-name=admin_db

<!-- generate crud and api -->
go run -tags generate generation-scripts/generate_crud_handlers.go --config=generation-scripts/config/crud-generation-config-admin.yaml

go mod tidy

<!-- auto reload -->
go run github.com/githubnemo/CompileDaemon@latest -command="./sdp-admin-api"

<!-- create main.go --># go-orm
