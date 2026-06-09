package decorator;

public class TrocaOleoDecorator extends ServicoDecorator {

    public TrocaOleoDecorator(ServicoOficina servicoDecorado) {
        super(servicoDecorado);
    }

    @Override
    public String getDescricao() {
        return super.getDescricao() + " + [Serviço: Troca de Óleo]";
    }
}