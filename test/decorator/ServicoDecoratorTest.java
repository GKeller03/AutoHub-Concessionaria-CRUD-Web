package decorator;

import model.Manutencao;
import java.sql.Date;
import org.junit.Test;
import static org.junit.Assert.*;

public class ServicoDecoratorTest {

    @Test
    public void deveMontarDescricaoApenasComManutencaoBasica() {
        Manutencao m = new Manutencao(new Date(System.currentTimeMillis()), "MANUTENÇÃO INICIADA", 1, 1);
        ServicoOficina servico = new ManutencaoBasica(m);

        String resultado = servico.getDescricao();

        assertEquals("MANUTENÇÃO INICIADA", resultado);
    }

    @Test
    public void deveDecorarComTrocaDeOleo() {
        Manutencao m = new Manutencao(new Date(System.currentTimeMillis()), "MANUTENÇÃO INICIADA", 1, 1);
        ServicoOficina servico = new ManutencaoBasica(m);
        servico = new TrocaOleoDecorator(servico);

        String resultado = servico.getDescricao();

        assertEquals("MANUTENÇÃO INICIADA + [Serviço: Troca de Óleo]", resultado);
    }

    @Test
    public void deveAcumularTodosOsDecoratorsSimultaneamente() {
        Manutencao m = new Manutencao(new Date(System.currentTimeMillis()), "MANUTENÇÃO INICIADA", 1, 1);
        ServicoOficina servico = new ManutencaoBasica(m);
        
        servico = new TrocaOleoDecorator(servico);
        servico = new TrocaPneuDecorator(servico);

        String resultado = servico.getDescricao();

        String esperado = "MANUTENÇÃO INICIADA + [Serviço: Troca de Óleo] + [Serviço: Troca de Pneu]";
        assertEquals(esperado, resultado);
    }
}