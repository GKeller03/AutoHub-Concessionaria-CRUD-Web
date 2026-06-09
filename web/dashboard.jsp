<%-- dashboard.jsp --%>
<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogado");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/index.html?erro=sessao");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AutoHub - Dashboard</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css">
    
    <style>
        .header-dash {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            width: 100%;
            max-width: 1000px;
            margin-bottom: 20px;
        }

        .btn-logout {
            color: var(--primary-red);
            text-decoration: none;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 1px;
        }

        .user-info {
            text-align: center;
            margin-bottom: 30px;
        }

        .user-info h2 {
            font-size: 28px;
            margin-bottom: 5px;
        }

        .section-card {
            background-color: #1a1a1a;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid var(--border-color);
        }

        .section-title {
            color: var(--text-white);
            text-transform: uppercase;
            letter-spacing: 2px;
            font-size: 18px;
            margin-bottom: 20px;
            text-align: center;
            border-bottom: 1px solid #333;
            padding-bottom: 10px;
        }

        .grid-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .btn-full {
            grid-column: span 2;
            margin-top: 10px;
            font-size: 18px;
            padding: 18px;
        }

        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        .alert-sucesso { background: #15572433; color: #28a745; border: 1px solid #28a745; }
        .alert-erro { background: #721c2433; color: #ff4444; border: 1px solid #ff4444; }
    </style>
</head>
<body>

<div class="header-dash" style="margin: 20px auto;">
    <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout">SAIR</a>
    <img src="${pageContext.request.contextPath}/resources/img/Logo-AutoHub.png" alt="AutoHub" style="max-width: 120px;">
</div>

<div class="container" style="max-width: 800px; padding-top: 20px;">
    
    <div class="user-info">
        <h2 style="color: var(--primary-red);">Olá, <%= user.getNome() %>!</h2>
        <p style="color: #888;">Nível de acesso: <span style="color: white;"><%= user.getTipoUsuario() %></span></p>
    </div>

    <%-- Mensagens de Feedback de Sucesso --%>
    <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-sucesso">✅ <%= request.getParameter("msg") %></div>
    <% } else if (request.getParameter("sucesso") != null && "venda".equals(request.getParameter("sucesso"))) { %>
        <div class="alert alert-sucesso">✅ Pedido processado com sucesso!</div>
    <% } %>
    
    <%-- Mensagens de Feedback de Erro (Trata Atributo e Parâmetro da URL) --%>
    <% 
        String msgErro = null;
        if (request.getAttribute("erro") != null) {
            msgErro = request.getAttribute("erro").toString();
        } else if (request.getParameter("erro") != null) {
            msgErro = request.getParameter("erro");
        }
        if (msgErro != null) { 
    %>
        <div class="alert alert-erro">❌ <%= msgErro %></div>
    <% } %>

    <%-- MENU GERAL (Sempre Visível) --%>
    <div class="section-card">
        <h3 class="section-title">Menu Geral</h3>
        <div class="grid-buttons">
            <a href="${pageContext.request.contextPath}/api/carro" class="btn-primary" style="background-color: #8b0000; min-width: 200px; text-align: center; text-decoration: none; line-height: 2.5;">VISUALIZAR ESTOQUE</a>
            
            <% if ("Administrador".equals(user.getTipoUsuario())) { %>
                <a href="${pageContext.request.contextPath}/gerenciar_oficina.jsp" class="btn-primary" style="background-color: #8b0000; min-width: 200px; text-align: center; text-decoration: none; line-height: 2.5;">GERENCIAR OFICINA</a>
            <% } %>
        </div>
    </div>

    <%-- ÁREA DE COMPRAS (Apenas CLIENTE) --%>
    <% if ("Cliente".equals(user.getTipoUsuario())) { %>
        <div class="section-card" style="border-top: 2px solid var(--primary-red);">
            <h3 class="section-title">Área de Compras</h3>
            <div style="text-align: center;">
                <a href="${pageContext.request.contextPath}/comprar_carro.jsp" class="btn-primary btn-full" style="text-decoration: none; display: block;">
                    FAZER PEDIDO
                </a>
            </div>
        </div>
    <% } %>