# AutoHub - Concessionaria Online

> Sistema web para gerenciamento de concessionaria com estoque, vendas, oficina, historico de manutencoes e autenticacao por perfil. Desenvolvido em Java com Servlets, JSP, JDBC, MySQL e padroes MVC, Command e Decorator.

![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)
![JDBC](https://img.shields.io/badge/JDBC-4479A1?style=for-the-badge&logo=databricks&logoColor=white)
![MVC](https://img.shields.io/badge/Pattern-MVC-blueviolet?style=for-the-badge)
![Command Pattern](https://img.shields.io/badge/Pattern-Command-orange?style=for-the-badge)
![Decorator Pattern](https://img.shields.io/badge/Pattern-Decorator-teal?style=for-the-badge)
![JUnit](https://img.shields.io/badge/Tests-JUnit-green?style=for-the-badge)

---

## Preview

| Login | Cadastro Cliente | Cadastro Admin |
|-------|------------------|----------------|
| ![Login](screenshots/login.png) | ![Cadastro Cliente](screenshots/cadastro-cliente.png) | ![Cadastro Admin](screenshots/cadastro-admin.png) |

| Dashboard Admin | Dashboard Cliente | Estoque |
|-----------------|-------------------|---------|
| ![Admin](screenshots/dashboard-admin.png) | ![Cliente](screenshots/dashboard-cliente.png) | ![Estoque](screenshots/estoque.png) |

| Controle de Oficina | Historico | Area de Compras |
|---------------------|-----------|-----------------|
| ![Oficina](screenshots/oficina.png) | ![Historico](screenshots/historico.png) | ![Compras](screenshots/pedido.png) |

---

## Sobre o Projeto

O **AutoHub** e uma aplicacao web para uma concessionaria. O sistema permite que administradores cadastrem, editem, excluam e acompanhem veiculos, enquanto clientes visualizam o estoque e registram pedidos de compra.

A versao atual tambem possui controle de oficina: carros podem entrar em manutencao, receber servicos adicionais como troca de oleo e troca de pneu, ter a manutencao finalizada e aparecer no historico com data de saida.

O projeto segue o padrao **MVC** e usa **Command Pattern** para encapsular acoes de negocio como login, cadastro, atualizacao de carro, pedido e manutencao. Para os servicos de oficina, usa **Decorator Pattern**, permitindo montar dinamicamente a descricao da manutencao conforme os adicionais selecionados.

---

## Funcionalidades

### Autenticacao e Controle de Acesso

- Login com email e senha.
- Cadastro de usuarios por perfil.
- Perfis de acesso: `Administrador` e `Cliente`.
- Sessao do usuario salva em `HttpSession`.
- Logout com invalidacao da sessao.
- Redirecionamento quando a sessao expira.

### Gestao de Estoque

- Cadastro de veiculos com modelo, preco, placa, cor e ano.
- Validacao de campos obrigatorios e ano com 4 digitos.
- Validacao de placa unica.
- Listagem de veiculos com status dinamico:
  - `Disponivel`
  - `Vendido`
  - `Manutencao`
- Edicao e exclusao de veiculos.
- Atualizacao automatica de status quando um pedido ou manutencao e registrado.

### Area de Compras

- Cliente visualiza carros disponiveis.
- Cliente registra pedido de compra.
- O pedido e salvo no banco e o carro passa para `Vendido`.
- Se um carro vendido voltar para `Disponivel`, o pedido relacionado pode ser removido pela regra de negocio.

### Controle de Oficina

- Registro de entrada de carro em manutencao.
- Finalizacao da manutencao.
- Atualizacao automatica do carro para `Disponivel` ao finalizar.
- Historico de manutencoes finalizadas.
- Registro de `data_saida` ao concluir a manutencao.
- Controle de revisao obrigatoria.

### Decorator em Manutencoes

- `ManutencaoBasica` representa o servico base.
- `TrocaOleoDecorator` adiciona troca de oleo a descricao.
- `TrocaPneuDecorator` adiciona troca de pneu a descricao.
- Os decorators podem ser combinados de acordo com os checkboxes selecionados na tela.
- A descricao final da manutencao e montada automaticamente antes de salvar no banco.

### Command Pattern

O sistema usa comandos para isolar as operacoes principais:

- `LoginCommand`
- `SalvarCarroCommand`
- `AtualizarCarroCommand`
- `ExcluirCarroCommand`
- `ListarCarrosCommand`
- `PedidoCommand`
- `RegistrarManutencaoCommand`
- `FinalizarManutencaoCommand`

### Testes

- Testes para o comportamento dos decorators.
- Testes para regras do `AtualizarCarroCommand`.
- Cobertura focada nas regras de manutencao, troca de oleo, troca de pneu e retorno de carro vendido para disponivel.

---

## Tecnologias

| Tecnologia | Uso |
|-----------|-----|
| Java | Linguagem principal |
| Jakarta Servlets | Controllers HTTP |
| JSP | Views dinamicas |
| JDBC | Acesso ao banco de dados |
| MySQL | Banco de dados relacional |
| Apache Tomcat / TomEE | Servidor de aplicacao |
| HTML / CSS | Interface web |
| JUnit | Testes automatizados |

---

## Estrutura do Projeto

```text
src/java/
  command/      # Commands das regras de negocio
  controller/   # Servlets
  dao/          # Acesso ao banco via JDBC
  decorator/    # Decorators da oficina
  model/        # Entidades do sistema
  util/         # Conexao com banco

web/
  *.jsp         # Telas dinamicas
  *.html        # Telas estaticas
  resources/    # CSS e imagens

test/
  command/      # Testes de commands
  decorator/    # Testes de decorators
```

---

## Como Executar

### 1. Clone o repositorio

```bash
git clone https://github.com/GKeller03/AutoHub-Concessionaria-CRUD-Web.git
cd AutoHub-Concessionaria-CRUD-Web
```

### 2. Configure o banco de dados

Execute um script compatibilizando as tabelas com os nomes usados pelos DAOs:

```sql
CREATE DATABASE autohub;
USE autohub;

CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(100) NOT NULL,
    tipoUsuario ENUM('Administrador', 'Cliente') NOT NULL,
    cpf VARCHAR(20),
    telefone VARCHAR(20),
    cargo VARCHAR(80)
);

CREATE TABLE Carro (
    idCarro INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    placa VARCHAR(10) UNIQUE NOT NULL,
    cor VARCHAR(30),
    ano INT NOT NULL,
    status ENUM('Disponível', 'Vendido', 'Manutenção') DEFAULT 'Disponível'
);

CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    idCarro INT NOT NULL,
    idUsuario INT NOT NULL,
    FOREIGN KEY (idCarro) REFERENCES Carro(idCarro),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE Manutencao (
    idManutencao INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    data_saida DATE,
    descricao TEXT,
    revisaoObrigatoria BOOLEAN DEFAULT FALSE,
    idCarro INT NOT NULL,
    idAdministrador INT NOT NULL,
    finalizada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idCarro) REFERENCES Carro(idCarro),
    FOREIGN KEY (idAdministrador) REFERENCES Usuario(idUsuario)
);

INSERT INTO Usuario (nome, email, senha, tipoUsuario, cargo)
VALUES ('Admin', 'admin@autohub.com', 'admin123', 'Administrador', 'Gerente');

INSERT INTO Usuario (nome, email, senha, tipoUsuario, cpf, telefone)
VALUES ('Cliente Teste', 'cliente@autohub.com', 'cliente123', 'Cliente', '000.000.000-00', '(00) 00000-0000');
```

### 3. Configure a conexao

Edite `src/java/util/DatabaseConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/autohub";
private static final String USER = "root";
private static final String PASSWORD = "sua_senha";
```

### 4. Execute no servidor

1. Importe o projeto na IDE.
2. Configure o Apache Tomcat/TomEE.
3. Execute o projeto no servidor.
4. Acesse a aplicacao no navegador pelo contexto configurado.

---

## Padroes de Projeto Aplicados

### Command

Os controllers recebem a requisicao HTTP, montam os dados necessarios e delegam a operacao para um command. Isso reduz a quantidade de regra de negocio dentro dos servlets e facilita manutencao.

### Decorator

O fluxo de oficina usa decorators para adicionar servicos a manutencao sem alterar a classe base. Assim, uma manutencao pode ser apenas basica, ou receber troca de oleo, troca de pneu, ou ambos.

---

## Autor

**Gabriel Keller**

- LinkedIn: https://www.linkedin.com/in/-gabriel-keller/
- Email: gabrielkeller03052005@gmail.com
