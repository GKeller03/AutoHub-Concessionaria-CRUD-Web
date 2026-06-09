package controller;

import command.Command;
import command.RegistrarManutencaoCommand;
import command.FinalizarManutencaoCommand;
import model.Manutencao;
import decorator.*; // CORREÇÃO 1: Importa todas as classes do novo pacote decorator
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "ManutencaoController", urlPatterns = {"/api/manutencao"})
public class ManutencaoController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Lógica para Finalizar vinda do botão na gerenciar_oficina.jsp
        if ("finalizar".equals(action)) {
            try {
                int idM = Integer.parseInt(request.getParameter("idManutencao"));
                int idC = Integer.parseInt(request.getParameter("idCarro"));
                
                Command cmd = new FinalizarManutencaoCommand(idM, idC);
                cmd.executar();
                
                // Redireciona de volta para a tabela de gerenciamento com mensagem de sucesso
                response.sendRedirect(request.getContextPath() + "/gerenciar_oficina.jsp?msg=Manutencao concluida e carro disponivel!");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?erro=" + e.getMessage());
            }
            return;
        }

        // Se a ação for listar, envia direto para o JSP que criamos
        if ("list".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/gerenciar_oficina.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("registrar".equals(action)) {
            try {
                int idCarro = Integer.parseInt(request.getParameter("idCarro"));
                int idAdm = Integer.parseInt(request.getParameter("idAdministrador"));
                String descricao = request.getParameter("descricao");
                Date data = Date.valueOf(request.getParameter("data"));
                boolean revisao = request.getParameter("revisaoObrigatoria") != null;

                // 1. Instancia o objeto model original com a descrição vinda da tela
                Manutencao m = new Manutencao(data, descricao, idCarro, idAdm);
                m.setRevisaoObrigatoria(revisao); 

                // 2. APLICAÇÃO DO DECORATOR: Criamos o componente básico (Sem o parâmetro de preço double)
                ServicoOficina servicoCompleto = new ManutencaoBasica(m);

                // 3. Verifica dinamicamente os parâmetros enviados pelas checkboxes da tela JSP
                if (request.getParameter("trocaOleo") != null) {
                    servicoCompleto = new TrocaOleoDecorator(servicoCompleto);
                }
                if (request.getParameter("trocaPneu") != null) {
                    servicoCompleto = new TrocaPneuDecorator(servicoCompleto);
                }

                // 4. Injeta apenas a descrição final gerada cumulativamente pelos Decorators (Sem preços)
                m.setDescricao(servicoCompleto.getDescricao());

                // 5. Executa o comando para persistência no banco
                Command cmd = new RegistrarManutencaoCommand(m);
                cmd.executar();

                // Retorna informando o sucesso
                response.sendRedirect(request.getContextPath() + "/gerenciar_oficina.jsp?msg=Veiculo registrado na oficina com adicionais!");

            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?erro=Erro ao registrar: " + e.getMessage());
            }
        }
    }
}