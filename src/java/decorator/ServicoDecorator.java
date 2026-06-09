package decorator;

public abstract class ServicoDecorator implements ServicoOficina {
    protected ServicoOficina servicoDecorado;

    public ServicoDecorator(ServicoOficina servicoDecorado) {
        this.servicoDecorado = servicoDecorado;
    }

    @Override
    public String getDescricao() {
        return servicoDecorado.getDescricao();
    }
}