# Imentore

Imentore e uma plataforma modular de e-commerce escrita em Ruby on Rails. O
repositorio reune uma aplicacao base e varias engines Rails que funcionam como
um monolito modular: loja publica, catalogo, carrinho, checkout, pedidos,
pagamentos, frete, CMS de paginas/temas/templates, autenticacao, painel
administrativo da loja, area do cliente e painel operacional da plataforma.

O sistema foi desenhado para operar em modo multi-loja. Cada loja e resolvida
pelo host da requisicao, normalmente por subdominio, e os dados de catalogo,
clientes, pedidos, temas, meios de pagamento e entregas ficam ligados a essa
loja.

## Modulos

- `imentore-base`: aplicacao Rails principal. Monta a engine core em `/`,
  concentra migrations consolidadas, configuracoes, observers e o ambiente de
  execucao da aplicacao completa.
- `imentore-core`: engine central. Fornece layouts, assets, controllers base e
  o helper que localiza a loja atual a partir do host da requisicao.
- `imentore-auth`: autenticacao Devise para usuarios da loja, clientes,
  administradores e manager global.
- `imentore-cms`: paginas, noticias, temas, templates Liquid e assets usados
  para renderizar a vitrine de cada loja.
- `imentore-dashboard`: dashboards e telas administrativas complementares,
  incluindo clientes, funcionarios, emails e enderecos do cliente.
- `imentore-ecommerce`: catalogo, categorias, produtos, variantes, imagens,
  carrinho, checkout, pedidos, cupons, metodos de pagamento, metodos de entrega,
  dominios e feedbacks.
- `imentore-manager`: painel operacional global da plataforma para gerenciar
  lojas, temas, templates, assets e emails padrao.
- `imentore-testing`: suporte de testes usado pelos modulos.
- `personhood`: camada auxiliar de identidade para pessoa/empresa e perfis
  `owner`/`admin`.

## Como o monorepo se conecta

A aplicacao base monta apenas `Imentore::Core::Engine` em `/`. As demais engines
nao sao montadas em paths separados; elas adicionam rotas dentro da propria
engine core usando `Imentore::Core::Engine.routes.draw`. Na pratica, todos os
modulos compartilham o namespace `Imentore` e aparecem na aplicacao final como
rotas diretas, por exemplo `/admin`, `/products`, `/cart`, `/client` e
`/manager`.

Alguns modulos tambem carregam arquivos `*_slice.rb` durante o `to_prepare` do
Rails. Esses slices reabrem controllers base para adicionar comportamento
transversal, como autorizacao de admin/cliente, carrinho atual e renderizacao de
templates Liquid por loja.

O fluxo principal de uma requisicao de loja e:

1. O request chega com um host, por exemplo `minhaloja.imentore.local`.
2. `current_store` procura uma loja pelo dominio cadastrado ou pelo subdominio.
3. O CMS injeta o tema/template ativo da loja.
4. As rotas de catalogo, carrinho, checkout, cliente e admin operam sempre sobre
   essa loja.

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

Sem uma loja cadastrada, `http://localhost:3000` redireciona para o site
institucional em `/site`. O e-commerce da loja depende de host/subdominio, entao
o primeiro passo em um banco novo e cadastrar uma loja.

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

## Acessando o e-commerce

O banco inicial nao possui seeds nem usuarios padrao. O arquivo
`imentore-base/db/seeds.rb` esta vazio; os dados basicos da loja sao criados
quando uma nova loja e cadastrada.

Para criar a primeira loja no Docker:

1. Acesse `http://localhost:3000/stores/new`.
2. Informe o endereco da loja, por exemplo `minhaloja`.
3. Informe o email e a senha do dono da loja.
4. Aceite os termos, escolha um plano e envie o formulario.
5. Se o fluxo legado redirecionar para `minhaloja.imentore.dev:4000`, abra a
   loja manualmente no host local configurado abaixo.

O cadastro executa `create_defaults` e cria para a loja:

- metodos de pagamento `MoIP`, `PagSeguro`, `Pagamento Digital` e `Custom`;
- metodos de entrega `SEDEX`, `SEDEX a Cobrar`, `Pac`, `Weight` e `Custom`;
- categoria e produto de exemplo;
- imagens de exemplo;
- emails padrao;
- tema/templates padrao.

### Host local da loja

Como a loja e resolvida pelo host, cadastre um alias local para cada loja que
for testar. Em Linux:

```sh
sudo sh -c 'echo "127.0.0.1 minhaloja.imentore.local" >> /etc/hosts'
```

Depois acesse:

```text
http://minhaloja.imentore.local:3000
```

O dominio `imentore.local` esta na configuracao do projeto e evita problemas de
HTTPS/HSTS comuns em navegadores modernos com dominios `.dev`. O codigo legado
ainda possui alguns redirects de desenvolvimento para `.imentore.dev:4000`; se
isso aparecer, use manualmente o host `.imentore.local:3000` enquanto estiver no
Docker atual.

### Area publica da loja

Use o host da loja, por exemplo `http://minhaloja.imentore.local:3000`.

Rotas publicas importantes:

- `/`: vitrine inicial da loja.
- `/products`: listagem de produtos.
- `/products/:id`: produto por ID.
- `/product/:handle`: produto por handle.
- `/categories/*categories`: categoria.
- `/pages/:page`: pagina CMS.
- `/notices/:handle`: noticia CMS.
- `/contact`: contato da loja.
- `/cart`: carrinho.
- `/checkouts`: inicia o checkout.

O checkout segue o fluxo:

- `/:store_id/checkouts/:order_id/address`
- `/:store_id/checkouts/:order_id/shipping`
- `/:store_id/checkouts/:order_id/payment`
- `/:store_id/checkouts/:order_id/complete`

### Area do cliente

A area do cliente pertence a uma loja especifica. Acesse sempre pelo host da
loja:

```text
http://minhaloja.imentore.local:3000/client/login
```

Clientes podem ser criados em:

```text
http://minhaloja.imentore.local:3000/customers/new
```

Apos login, o dashboard do cliente fica em:

```text
http://minhaloja.imentore.local:3000/client
```

Rotas principais do cliente:

- `/client`: dashboard do cliente.
- `/client/address`: enderecos.
- `/client/login`: login.
- `/client/logout`: logout.

Usuarios com perfil `owner` ou `admin` nao acessam a area de cliente; eles sao
redirecionados para a area administrativa.

### Area administrativa da loja

A area administrativa tambem depende do host da loja:

```text
http://minhaloja.imentore.local:3000/admin/login
```

Use o email e a senha informados ao cadastrar a loja. Esse usuario e criado como
dono da loja (`owner`) e tem acesso ao painel administrativo.

Apos login:

```text
http://minhaloja.imentore.local:3000/admin
```

Rotas administrativas importantes:

- `/admin`: dashboard.
- `/admin/store`: dados gerais da loja.
- `/admin/store/settings/:group`: configuracoes, como o grupo `virtual`.
- `/admin/products`: produtos.
- `/admin/products/:product_id/options`: opcoes de produto.
- `/admin/products/:product_id/variants`: variantes de produto.
- `/admin/categories`: categorias.
- `/admin/orders`: pedidos.
- `/admin/coupons`: cupons.
- `/admin/payment-methods`: metodos de pagamento.
- `/admin/delivery-methods`: metodos de entrega.
- `/admin/customers`: clientes.
- `/admin/employees`: usuarios administrativos da loja.
- `/admin/pages`: paginas CMS.
- `/admin/notices`: noticias CMS.
- `/admin/themes`: temas, templates e assets.
- `/admin/domains`: dominios da loja.
- `/admin/send_emails`: modelos de email.
- `/admin/feedbacks`: mensagens/feedbacks.

Administradores adicionais podem ser criados em `/admin/employees`; o controller
atribui `department = "admin"` ao novo funcionario.

### Manager global

O manager e diferente do admin da loja. Ele e uma area operacional da plataforma
para instalar/atualizar lojas, temas, templates, assets e emails globais:

```text
http://localhost:3000/manager/login
```

O codigo permite acesso ao manager apenas para o email
`admin@imentore.com.br`. Nao ha seed nem senha padrao para esse usuario no
repositorio.

## Licenca

Copyright 2018 Breno Perucchi.
