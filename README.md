# Registro de Campo - UC13

Primeiro incremento pratico da UC13. O aplicativo registra visitas tecnicas e mantem os dados localmenteem SQLite, mesmo sem internet.

## Ambiente validado

- Flutter 3.44.0 (stable)
- Dart 3.12.0
- 'sqflite' 2.4.3
- 'path' 1.9.1
- 'uuid' 4.6.0
- Android como plataforma de proejto

## Funcionalidades deste incremento

- criaçao automatica do banco 'registro-campo.db'
- categorias iniciais;
- cadastro, consulta, ediçao e exclusao de registros;
- identificadores UUID;
- estados de carregamento, lista vazia e falha;
- separaçao entre interfaces, repositorio, DAO e banco;
- testes de modelo, SQLite e interface.

## Como executar

1. Instale o Flutter e o Android Studio.
2. Na raiz do projeto, confira o ambiente:

    ```bash
    flutter doctor -v
    flutter devices
    ```
3. Resolva as dependencias:

    ```bash
    flutter pub get
    ```
   
4. Inicie um emulador Android ou Conecte um aparelho com depuraçao USB.
5. Execute:

    ```bash
    flutter run
    ```
   
## Como verificar o projeto

    ```bash
    dart format --output=none --set-exit-if-changed lib test
    flutter analyze
    flutter test
    ``` 

## Estrutura principal

```text



```

## Problemas frequentes

- Execute os comandos na pasta que contem 'pubsec.yalm'.
- Nao use espaços nonnome do projeto.
- Resolva erros do 'Flutter doctor' antes de alterar o codigo Dart.
- Se o banco mudardurante o desenvolvimento, aumente a versao e crie uma migraçao, Nao apague dados do usuario como estrategia de produçao.