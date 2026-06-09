package decorator;

import model.Manutencao;

public class ManutencaoBasica implements ServicoOficina {
    private final Manutencao manutencao;

    public ManutencaoBasica(Manutencao manutencao) {
        this.manutencao = manutencao;
    }

    @Override
    public String getDescricao() {
        return manutencao.getDescricao(); // Retorna o texto inicial ("MANUTENÇÃO INICIADA")
    }
}