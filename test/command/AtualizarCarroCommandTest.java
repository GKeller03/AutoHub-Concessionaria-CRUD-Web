package command;

import dao.CarroDAO;
import dao.PedidoDAO;
import dao.ManutencaoDAO;
import model.Carro;
import org.junit.Test;
import static org.junit.Assert.*;
import java.lang.reflect.Field;

public class AtualizarCarroCommandTest {

    @Test
    public void deveExcluirPedidoQuandoCarroMudarDeVendidoParaDisponivel() throws Exception {
        Carro carroAlterado = new Carro("Civic", 90000.0, "ABC-1234", "Preto", 2020);
        carroAlterado.setIdCarro(1);
        carroAlterado.setStatus("Disponível");

        CarroDAOFake carroDAOFake = new CarroDAOFake();
        PedidoDAOFake pedidoDAOFake = new PedidoDAOFake();
        ManutencaoDAO manutencaoDAOStub = new ManutencaoDAO() {
            @Override
            public void registrarEntrada(model.Manutencao m) {}
        };

        AtualizarCarroCommand comando = new AtualizarCarroCommand(carroAlterado, 1, false, false);

        injetarMock(comando, "carroDAO", carroDAOFake);
        injetarMock(comando, "pedidoDAO", pedidoDAOFake); // CORREÇÃO: Passando o objeto direto
        injetarMock(comando, "manutencaoDAO", manutencaoDAOStub);

        comando.executar();

        assertTrue(pedidoDAOFake.metodoExcluirFoiChamado);
        assertEquals(1, pedidoDAOFake.idCarroRecebido);
        assertTrue(carroDAOFake.metodoAtualizarFoiChamado);
    }

    private void injetarMock(Object target, String fieldName, Object mock) throws Exception {
        Field field = target.getClass().getDeclaredField(fieldName);
        field.setAccessible(true);
        field.set(target, mock);
    }

    private static class CarroDAOFake extends CarroDAO {
        boolean metodoAtualizarFoiChamado = false;

        @Override
        public Carro buscarPorId(int id) {
            Carro antigo = new Carro("Civic", 90000.0, "ABC-1234", "Preto", 2020);
            antigo.setIdCarro(id);
            antigo.setStatus("Vendido");
            return antigo;
        }

        @Override
        public void atualizar(Carro c) {
            this.metodoAtualizarFoiChamado = true;
        }
    }

    private static class PedidoDAOFake extends PedidoDAO {
        boolean metodoExcluirFoiChamado = false;
        int idCarroRecebido = -1;

        @Override
        public void excluirPorCarro(int idCarro) {
            this.metodoExcluirFoiChamado = true;
            this.idCarroRecebido = idCarro;
        }
    }
}