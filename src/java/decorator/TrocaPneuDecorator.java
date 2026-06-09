package decorator;

public class TrocaPneuDecorator extends ServicoDecorator {

    public TrocaPneuDecorator(ServicoOficina servicoDecorado) {
        super(servicoDecorado);
    }

    @Override
    public String getDescricao() {
        return super.getDescricao() + " + [Serviço: Troca de Pneu]";
    }
}