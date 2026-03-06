# flutter-clean-architecture-exercicio

Questionário de Reflexão (Atividade 2)

---

**Em qual camada foi implementado o cache e por que?**

O cache foi implementado na camada data pois ela é a responsável por gerenciar toda a infraestrutura e as fontes de dados da aplicação. Essa escolha garante a correta separação de responsabilidades, isolando o gerenciamento do cache das regras de negócio (camada domain) e da apresentação.

---

**Por que o ViewModel nao realiza chamadas HTTP diretamente?**

O ViewModel não realiza chamadas HTTP diretamente porque sua única função na camada presentation é gerenciar o estado da interface. Fazer requisições de rede acoplaria a lógica de apresentação à de infraestrutura, o que violaria a separação de camadas e resultaria em um código muito mais difícil de testar, complexo de manter e incapaz de ter suas regras de negócio reutilizadas.

---

**O que aconteceria se a interface acessasse diretamente o datasource?**

Se a interface acessasse o datasource diretamente, ela ficaria fortemente acoplada aos detalhes de implementação dos dados, resultando em um código frágil e muito mais difícil de testar. Sem as camadas intermediárias, qualquer mudança na infraestrutura (como trocar uma API ou adicionar cache) exigiria alterações diretas na UI, e não haveria um local adequado para tratar erros, transformar dados ou aplicar regras de negócio.

---

**Como essa arquitetura facilitaria a substituição da API por um banco de dados local?**

A substituição seria simples, bastaria criar o novo repositório na camada data e atualizar a injeção de dependências. Graças ao uso de abstrações, não seria necessário alterar absolutamente nenhuma linha de código nas camadas de negócio (domain) ou de interface (presentation).