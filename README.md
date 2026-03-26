# flutter-clean-architecture-exercicio

---

Questionário (Atividade 2)

    Em qual camada foi implementado o cache e por que?

    O cache foi implementado na camada data pois ela é a responsável por gerenciar toda a infraestrutura e as fontes de dados da aplicação. Essa escolha garante a correta separação de responsabilidades, isolando o gerenciamento do cache das regras de negócio (camada domain) e da apresentação.

    Por que o ViewModel nao realiza chamadas HTTP diretamente?

    O ViewModel não realiza chamadas HTTP diretamente porque sua única função na camada presentation é gerenciar o estado da interface. Fazer requisições de rede acoplaria a lógica de apresentação à de infraestrutura, o que violaria a separação de camadas e resultaria em um código muito mais difícil de testar, complexo de manter e incapaz de ter suas regras de negócio reutilizadas.

    O que aconteceria se a interface acessasse diretamente o datasource?

    Se a interface acessasse o datasource diretamente, ela ficaria fortemente acoplada aos detalhes de implementação dos dados, resultando em um código frágil e muito mais difícil de testar. Sem as camadas intermediárias, qualquer mudança na infraestrutura (como trocar uma API ou adicionar cache) exigiria alterações diretas na UI, e não haveria um local adequado para tratar erros, transformar dados ou aplicar regras de negócio.

    Como essa arquitetura facilitaria a substituição da API por um banco de dados local?

    A substituição seria simples, bastaria criar o novo repositório na camada data e atualizar a injeção de dependências. Graças ao uso de abstrações, não seria necessário alterar absolutamente nenhuma linha de código nas camadas de negócio (domain) ou de interface (presentation).

---

Questionário (Atividade 06)

    1. O que significa gerenciamento de estado em uma aplicação Flutter?

    É como a gente controla e compartilha os dados que mudam na tela tipo lista de produtos, loading e favoritos. Sem isso, os dados ficam perdidos pelos widgets e a tela acaba não mostrando o que realmente esta acontecendo no app.

    2. Por que manter o estado diretamente dentro dos widgets pode gerar problemas em aplicações maiores?

    Porque o dado fica preso naquele widget. Se outra parte da tela precisar da mesma informaçao, você tem que duplicar codigo ou ficar passando dados de pai para filho pelo setState, em apps maiores isso vira uma bagunça e fica pessimo para dar manutençao.

    3. Qual é o papel do método notifyListeners() na abordagem Provider?
    
    Ele é o sinal de alerta. Quando alguma informaçao muda, o notifyListeners() avisa os widgets que estao escutando aquele Provider para eles se atualizarem na tela com o novo dado.

    4. Qual é a principal diferença conceitual entre Provider e Riverpod?

    O Provider é preso a arvore de widgets, ja o Riverpod resolve isso sendo global e independente da arvore, o que deixa muito mais facil acessar os dados de qualquer lugar e fazer testes.

    5. No padrão BLoC, por que a interface não altera diretamente o estado da aplicação?

    Para separar a logica da tela, no BLoC a tela so envia eventos, o BLoC recebe, processa a regra de negocio e devolve um novo estado e a tela so obedece e reage, isso deixa o app mais previsivel.

    6. Considere o fluxo do padrão BLoC:
    Evento → Bloc → Novo estado → Interface
    Qual é a vantagem de organizar o fluxo dessa forma?

    Como o fluxo é de mao unica, voce sempre sabe de onde veio a mudança, tudo passa obrigatoriamente pelo BLoC, isso facilita muito rastrear bugs e permite testar a lógica isoladamente, sem precisar interagir com a interface.

    7. Qual estratégia de gerenciamento de estado foi utilizada em sua implementação?

    Usei o Provider, com o ProductViewModel estendendo ChangeNotifier, configurei o provedor no main.dart e na tela uso context.watch() para reagir às mudanças e context.read() para disparar ações como carregar produtos ou favoritar.
    
    8. Durante a implementação, quais foram as principais dificuldades encontradas?

    O mais chato foi acertar o uso do copyWith no estado para nao acabar apagando dados que ja existiam quando eu queria alterar so uma propriedade.

---

Questionário (Atividade 07)

    1. Qual era a estrutura do seu projeto antes da inclusão das novas telas?

    Antes havia apenas a ProductPage como tela principal, com o ProductViewModel e o ProductState, e os modelos/entidades sem description e category.

    2. Como ficou o fluxo da aplicação após a implementação da navegação?

    Agora o fluxo e HomePage -> ProductPage -> ProductDetailPage, com retorno usando o back para a tela anterior em cada etapa.

    3. Qual é o papel do Navigator.push() no seu projeto?

    Ele empilha uma nova rota na pilha de navegaçao, permitindo abrir a ProductPage e a ProductDetailPage.

    4. Qual é o papel do Navigator.pop() no seu projeto?

    Ele desempilha a rota atual e retorna para a tela anterior (voltar da ProductDetailPage para ProductPage e depois para HomePage).

    5. Como os dados do produto selecionado foram enviados para a tela de detalhes?

    Eu passei o objeto Product pelo construtor do ProductDetailPage, usando ProductDetailPage(product: product).

    6. Por que a tela de detalhes depende das informações da tela anterior?

    Porque a tela anterior ja tem o produto selecionado, assim os detalhes sao exibidos sem nova busca e mantendo o contexto do item escolhido.

    7. Quais foram as principais mudanças feitas no projeto original?

    Adicionei HomePage e ProductDetailPage, coloquei a HomePage como home, criei a navegaçao entre telas, e expandi os modelos/entidades para incluir description e category.

    8. Quais dificuldades você encontrou durante a adaptação do projeto para múltiplas telas?

    O principal foi lembrar de atualizar o mapeamento de dados e os imports das novas telas.

