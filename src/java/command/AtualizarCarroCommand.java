package command;

import dao.CarroDAO;
import dao.PedidoDAO;
import dao.ManutencaoDAO;
import model.Carro;
import model.Manutencao;
import decorator.*; // Importa o novo pacote de decorators
import java.sql.Date;

public class AtualizarCarroCommand implements Command {
    private final Carro carro;
    private final int idUsuarioLogado;
    private final boolean trocaOleo;
    private final boolean trocaPneu;
    private final CarroDAO carroDAO;
    private final PedidoDAO pedidoDAO;
    private final ManutencaoDAO manutencaoDAO;

    public AtualizarCarroCommand(Carro carro, int idUsuarioLogado, boolean trocaOleo, boolean trocaPneu) {
        this.carro = carro;
        this.idUsuarioLogado = idUsuarioLogado;
        this.trocaOleo = trocaOleo;
        this.trocaPneu = trocaPneu;
        this.carroDAO = new CarroDAO();
        this.pedidoDAO = new PedidoDAO();
        this.manutencaoDAO = new ManutencaoDAO();
    }

    @Override
    public void executar() throws Exception {
        Carro carroAntigo = carroDAO.buscarPorId(carro.getIdCarro());

        // 1. RN: VENDIDO -> DISPONÍVEL (Limpa pedido)
        if ("Vendido".equals(carroAntigo.getStatus()) && "Disponível".equals(carro.getStatus())) {
            pedidoDAO.excluirPorCarro(carro.getIdCarro());
        }

        // 2. RN: NOVO STATUS = MANUTENÇÃO (Aplica o Decorator de verdade)
        if (!"Manutenção".equals(carroAntigo.getStatus()) && "Manutenção".equals(carro.getStatus())) {
            
            // Instancia a model de manutenção com o texto base inicial
            Manutencao m = new Manutencao(
                new Date(System.currentTimeMillis()), 
                "MANUTENÇÃO INICIADA", 
                carro.getIdCarro(), 
                idUsuarioLogado
            );

            // Cria o componente concreto a ser decorado
            ServicoOficina servico = new ManutencaoBasica(m);

            // Aplica os decorators dinamicamente baseado nos checkboxes da tela
            if (trocaOleo) {
                servico = new TrocaOleoDecorator(servico);
            }
            if (trocaPneu) {
                servico = new TrocaPneuDecorator(servico);
            }

            // O método getDescricao() vai percorrer a árvore de objetos e montar a string final acumulada
            m.setDescricao(servico.getDescricao());

            // Grava no banco de dados
            manutencaoDAO.registrarEntrada(m);
        }

        // 3. Atualiza o carro normalmente
        carroDAO.atualizar(carro);
    }
}