<%-- comprar_carro.jsp --%>
<%@page import="model.Usuario"%>
<%@page import="model.Carro, java.util.List, dao.CarroDAO"%>
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
    <title>AutoHub - Escolha seu Carro</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css">
    
    <style>
        .header-shopping {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 40px;
            max-width: 1400px;
            margin: 0 auto;
            gap: 20px;
        }

        .btn-return {
            color: white;
            text-decoration: none;
            text-transform: uppercase;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: color 0.3s;
        }
        
        .btn-return:hover { color: var(--primary-red); }

        .shop-title {
            text-transform: uppercase; 
            letter-spacing: 3px; 
            color: white; 
            margin: 0; 
            text-align: center;
            flex-grow: 1;
        }

        .user-badge {
            text-align: right;
            min-width: 150px;
        }

        .shop-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
            padding: 20px;
            max-width: 1300px;
            margin: 0 auto;
        }

        .buy-card {
            background-color: #181818;
            border-radius: 15px;
            padding: 30px;
            border: 1px solid #282828;
            text-align: center;
            transition: all 0.3s ease;
        }

        .buy-card:hover {
            transform: scale(1.02);
            border-color: var(--primary-red);
            box-shadow: 0 10px 20px rgba(0,0,0,0.5);
        }

        .badge-available {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: bold;
            color: #82f011;
            border: 1px solid #82f011;
            text-transform: uppercase;
            margin-bottom: 20px;
        }

        .car-name {
            font-size: 24px;
            font-weight: bold;
            color: white;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .car-price {
            color: var(--primary-red);
            font-size: 26px;
            font-weight: 900;
            margin-bottom: 20px;
        }

        .car-specs {
            color: #888;
            font-size: 14px;
            text-transform: uppercase;
            margin-bottom: 25px;
            line-height: 1.8;
        }

        .btn-action-buy {
            display: block;
            width: 100%;
            background-color: var(--primary-red);
            color: white;
            border: none;
            padding: 15px;
            border-radius: 8px;
            font-weight: bold;
            text-transform: uppercase;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-action-buy:hover {
            background-color: #a00000;
        }

        .empty-state {
            grid-column: 1/-1;
            text-align: center;
            padding: 100px 20px;
            color: #555;
        }
    </style>
</head>
<body>

    <div class="header-shopping">
        <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn-return">
            <span style="font-size: 24px;">⬅</span> RETORNAR
        </a>

        <h1 class="shop-title">Escolha seu Novo Carro</h1>

        <div class="user-badge">
            <img src="${pageContext.request.contextPath}/resources/img/Logo-AutoHub.png" alt="AutoHub" style="max-width: 100px;"><br>
            <span style="font-size: 12px; color: #888;">Cliente: <strong style="color: var(--primary-red);"><%= user.getNome().toUpperCase() %></strong></span>
        </div>
    </div>

    <div class="shop-grid">
        <%
            CarroDAO dao = new CarroDAO();
            List<Carro> disponiveis = dao.listarDisponiveis();
            
            if (disponiveis != null && !disponiveis.isEmpty()) {
                for(Carro c : disponiveis) {
        %>
            <div class="buy-card">
                <span class="badge-available">Disponível</span>
                
                <div class="car-name"><%= c.getModelo() %></div>
                <div class="car-price">R$ <%= String.format("%,.2f", c.getPreco()) %></div>
                
                <div class="car-specs">
                    Ano: <%= c.getAno() %> • Cor: <%= c.getCor() %><br>
                    Pronto para entrega imediata
                </div>

                <form action="${pageContext.request.contextPath}/pedido" method="POST">
                    <input type="hidden" name="idCarro" value="<%= c.getIdCarro() %>">
                    <input type="hidden" name="valor" value="<%= c.getPreco() %>">
                    <button type="submit" class="btn-action-buy">Comprar Agora</button>
                </form>
            </div>
        <% 
                }
            } else { 
        %>
            <div class="empty-state">
                <h2>Nenhum veículo disponível no momento.</h2>
                <p>Nossos carros estão correndo rápido! Volte em breve para novas ofertas.</p>
            </div>
        <% } %>
    </div>

</body>
</html>