# Imentore

Imentore e uma plataforma modular de e-commerce escrita em Ruby on Rails. O
repositorio reune engines e uma aplicacao base que cobrem autenticacao,
conteudo, catalogo, pedidos, painel administrativo e suporte de testes.

## Modulos

- `imentore-base`: aplicacao Rails principal.
- `imentore-core`: componentes compartilhados, layouts, helpers e assets.
- `imentore-auth`: autenticacao e integracao com usuarios.
- `imentore-cms`: gerenciamento de conteudo.
- `imentore-dashboard`: painel administrativo.
- `imentore-ecommerce`: catalogo, carrinho, pedidos e pagamentos.
- `imentore-manager`: gerenciamento complementar da operacao.
- `imentore-testing`: suporte de testes usado pelos modulos.
- `personhood`: camada auxiliar de identidade.

## Linguagem do repositorio

O projeto e primariamente Ruby. Bibliotecas, demos, arquivos temporarios e
source maps que nao eram usados pelo runtime foram removidos para reduzir o peso
de JavaScript/CSS vendorizado no repositorio. Os assets de terceiros que ainda
fazem parte do pipeline antigo do Rails/Sprockets permanecem versionados e sao
marcados em `.gitattributes` como vendorizados.

Para conferir a classificacao localmente:

```sh
RBENV_VERSION=3.4.7 bundle install
RBENV_VERSION=3.4.7 bundle exec github-linguist
```

## Dependencias

Os modulos foram criados no ecossistema Rails 4 e mantem Gemfiles proprios. Para
evitar divergencia entre engines conectadas por `path`, as dependencias comuns
ficam centralizadas em `Gemfile.rails` e cada modulo importa esse arquivo com
`eval_gemfile`.

O `Gemfile` da raiz e reservado para ferramentas de manutencao do repositorio,
como `github-linguist`. Ele nao carrega o stack Rails legado.

Os lockfiles antigos dos modulos foram removidos porque estavam obsoletos e
registravam versoes de Rails diferentes entre si. O lockfile de
`imentore-base` foi regenerado pelo ambiente Docker, que e o caminho recomendado
para executar a aplicacao completa.

Para trabalhar em um modulo especifico, entre no diretorio correspondente e
rode:

```sh
rbenv install 2.2.0
rbenv local 2.2.0
gem install bundler -v 1.17.3
bundle _1.17.3_ install
```

Em Linux moderno, algumas gems nativas antigas precisam de configuracao de
build antes do `bundle install`:

```sh
bundle _1.17.3_ config build.nokogiri --use-system-libraries
bundle _1.17.3_ config build.ffi "--with-cflags=-std=gnu89 -Wno-error=implicit-function-declaration -Wno-implicit-function-declaration"
```

A resolucao dos Gemfiles foi validada com Ruby 2.2.0 e Bundler 1.17.3. Em host
moderno, a instalacao completa ainda pode falhar por toolchain, Qt WebKit e
gems nativas antigas. Use Docker para isolar essas dependencias.

## Docker

O ambiente Docker usa Ruby 2.3.8, Rails 4.0.13 e MySQL 5.6. Ruby 2.3.8 ainda
fica proximo do stack legado, mas permite instalar `mimemagic 0.3.10`; Ruby 2.2
nao entende a sintaxe usada por essa gem.

Para preparar e rodar:

```sh
docker compose build app
docker compose up -d db
docker compose run --rm app bundle exec rake db:migrate
docker compose up -d app
```

A aplicacao fica disponivel em:

```text
http://localhost:3000
```

Comandos uteis:

```sh
docker compose logs -f app
docker compose run --rm app bundle check
docker compose run --rm app bundle exec rails runner 'puts Rails.version'
docker compose down
```

Quando alterar dependencias em `Gemfile.rails` ou nos Gemfiles dos modulos,
rode novamente `docker compose build app`.

Observacao: `ruby-plesk` permanece comentada em `Gemfile.rails` porque o
gemspec atual dessa dependencia ainda usa uma descricao `TODO`, que Bundler
atual rejeita. Corrija esse gemspec antes de reativar a integracao Plesk no
bundle principal.

## Licenca

Copyright 2018 Breno Perucchi.
