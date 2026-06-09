<%@page import="model.Manutencao, java.util.List, dao.ManutencaoDAO"%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogado");
    if (user == null || !"Administrador".equals(user.getTipoUsuario())) {
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp?erro=Acesso negado");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoHub - Controle da Oficina</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css">
    
    <style>
        body {
            background-color: #0a0a0a;
            color: white;
            padding: 40px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .container-oficina {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header-painel {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h2 {
            text-transform: uppercase;
            letter-spacing: 2px;
            font-size: 24px;
            margin: 0;
        }

        .sub-header {
            color: #888;
            margin-bottom: 20px;
            font-size: 14px;
        }

        /* Tabela Estilo Industrial */
        .tabela-oficina {
            width: 100%;
            border-collapse: collapse;
            background-color: #111;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #222;
        }

        .tabela-oficina th {
            background-color: #222;
            color: white;
            text-transform: uppercase;
            font-size: 13px;
            padding: 15px;
            text-align: center;
            letter-spacing: 1px;
            border-bottom: 2px solid #333;
        }

        .tabela-oficina td {
            padding: 20px;
            border-bottom: 1px solid #222;
            text-align: center;
            font-size: 14px;
        }

        /* Badges Lógicas */
        .badge-servico { color: #82f011; font-family: monospace; }
        .badge-revisao-nao { color: #ff4444; font-weight: bold; }
        .badge-revisao-sim { color: #82f011; font-weight: bold; }
        
        .badge-decorada {
            display: inline-block;
            background-color: #222;
            color: #82f011;
            border: 1px solid #333;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: bold;
            margin-left: 5px;
        }

        .status-reparo {
            background-color: #ffb84d;
            color: white;
            padding: 6px 15px;
            border-radius: 15px;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 11px;
        }

        .btn-acao-finalizar {
            background-color: #82f011;
            color: black;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 900;
            text-transform: uppercase;
            font-size: 12px;
            transition: 0.3s;
            display: inline-block;
        }

        .btn-acao-finalizar:hover {
            background-color: #a2ff4d;
            transform: scale(1.05);
            box-shadow: 0 0 15px rgba(130, 240, 17, 0.4);
        }

        .btn-history {
            color: white;
            text-decoration: none;
            font-size: 12px;
            font-weight: bold;
            border: 1px solid #444;
            padding: 10px 15px;
            border-radius: 5px;
            transition: 0.3s;
        }

        .btn-history:hover { border-color: #82f011; color: #82f011; }
        .back-link {
            display: inline-block;
            margin-top: 30px;
            color: white;
            text-decoration: none;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 12px;
        }
    </style>
</head>
<body>

    <div class="container-oficina">
        <div class="header-painel">
            <h2>Controle da Oficina</h2>
            <div style="display: flex; gap: 20px; align-items: center;">
                <a href="historico_manutencao.jsp" class="btn-history">📜 VER HISTÓRICO</a>
                <img src="${pageContext.request.contextPath}/resources/img/Logo-AutoHub.png" alt="AutoHub" style="max-width: 100px;">
            </div>
        </div>

        <p class="sub-header">Gerencie os veículos que estão em reparo ou revisão ativa</p>

        <table class="tabela-oficina">
            <thead>
                <tr>
                    <th>Entrada</th>
                    <th>Carro (ID)</th>
                    <th>Serviço</th>
                    <th>Revisão</th>
                    <th>Status</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ManutencaoDAO dao = new ManutencaoDAO();
                    List<Manutencao> listaOficina = dao.listarAtivas(); 
                    
                    if (listaOficina != null && !listaOficina.isEmpty()) {
                        for (Manutencao m : listaOficina) {
                            String descLower = m.getDescricao() != null ? m.getDescricao().toLowerCase() : "";
                %>
                <tr>
                    <td class="badge-servico"><%= m.getData() %></td>
                    <td style="font-weight: bold; color: white;">#<%= m.getIdCarro() %></td>
                    <td style="color: #bbb; text-align: left; max-width: 450px;">
                        <span><%= (m.getDescricao() == null || m.getDescricao().isEmpty()) ? "MANUTENÇÃO INICIADA" : m.getDescricao().toUpperCase() %></span>
                        
                        <%-- RENDERIZAÇÃO VISUAL BASEADA NO DECORATOR EMbutido NA STRING --%>
                        <% if (descLower.contains("óleo") || descLower.contains("oleo")) { %>
                            <span class="badge-decorada">🛢️ ÓLEO</span>
                        <% } %>
                        <% if (descLower.contains("pneu")) { %>
                            <span class="badge-decorada">🛞 PNEU</span>
                        <% } %>
                    </td>
                    <td>
                        <span class="<%= m.isRevisaoObrigatoria() ? "badge-revisao-sim" : "badge-revisao-nao" %>">
                            <%= m.isRevisaoObrigatoria() ? "SIM" : "NÃO" %>
                        </span>
                    </td>
                    <td><span class="status-reparo">Em Reparo</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/api/manutencao?action=finalizar&idManutencao=<%= m.getIdManutencao() %>&idCarro=<%= m.getIdCarro() %>" 
                           class="btn-acao-finalizar" 
                           onclick="return confirm('Confirmar a finalização do serviço no veículo #<%= m.getIdCarro() %>?')">
                            Finalizar
                        </a>
                    </td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr>
                    <td colspan="6" style="padding: 50px; color: #555;">
                        🚀 Todos os veículos foram liberados. Oficina vazia!
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <a href="dashboard.jsp" class="back-link">⬅ Voltar ao Painel</a>
    </div>

</body>
</html>