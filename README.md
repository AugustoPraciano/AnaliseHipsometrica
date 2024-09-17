# AnaliseHipsometrica
Script elaborado para gerar curvas hipsométricas de bacias hidrográficas e calcular a integral hipsométrica (Hi).
A pasta analise hidrologica / curva hipsometrica contém dados de exemplo. Os dados de entrada correspondem a arquivos
.csv com uma coluna "Area" área acumulada em porcentagem acima da cota altimetrica correspondente, expressa na coluna "Elevacao". Esse script foi criado originalmente para gerar curvas hipsometricas a partir dos dados gerados pela ferramenta "curvas hipsométricas" do software Qgis. Essa ferramenta até o momento da publicação retorna a área acumulada abaixo da cota correspondente, Portanto, é necessário, primeiramente, que se inverta os valores para area acumulada acima da cota correspondente, começando por 100 e posteriormente subtraindo de 100 a cota acumulada imediatamente abaixo.

![image](https://github.com/user-attachments/assets/961f6e12-2d20-40b0-b8ba-42f1b49060da)
