// Importa os widgets do Flutter
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

// Componente visual reutilizável para exibir um card de produto
class ProdutoCardBase extends StatelessWidget {
  // Nome do produto
  final String nome;

  // Caminho da imagem do produto (deve estar no assets)
  final String imagem;

  // Preço total do produto (considerando quantidade, se for o caso)
  final double precoTotal;

  // Widget externo que exibe controle de quantidade (ex: botões + e -)
  final Widget quantidadeWidget;

  // Widget extra opcional (ex: descrição, categoria, ingredientes...)
  final Widget? extraWidget;

  // Callback que será chamado ao clicar no botão "ADICIONAR"
  final VoidCallback onAdicionar;

  // Construtor da classe
  const ProdutoCardBase({
    super.key,
    required this.nome,
    required this.imagem,
    required this.precoTotal,
    required this.quantidadeWidget,
    this.extraWidget,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double imgMaxSize = screenWidth < 600 ? 120 : 180; // aumente aqui se quiser

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.pretoClaro,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Informações do produto (nome, chips, quantidade)
                Expanded(
                  flex: 4, // Diminua para 2 se quiser a imagem ainda maior
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: TextStyle(
                          color: AppColors.branco,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Bebas Neue',
                        ),
                      ),
                      if (extraWidget != null) ...[
                        const SizedBox(height: 8),
                        extraWidget!,
                      ],
                      const SizedBox(height: 8),
                      quantidadeWidget,
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Imagem do produto, agora ocupando mais espaço horizontal
                Flexible(
                  flex: 2, // Aumente para 3 se quiser a imagem ainda maior
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: nome.toLowerCase().contains('coca') && nome.contains('2')
                          ? Image.asset(
                              imagem,
                              fit: BoxFit.contain, // Corrige o zoom só para Coca 2L
                              width: 140,
                              height: 140,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 90,
                                height: 90,
                                color: Colors.black,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            )
                          : Image.asset(
                              imagem,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 90,
                                height: 90,
                                color: Colors.black,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32), // Espaço entre a imagem e o valor
          // Linha de valor e botão adicionar, abaixo de tudo
          LayoutBuilder(
            builder: (context, constraints) {
              double minButtonWidth = 90;
              double maxButtonWidth = 180;
              double buttonWidth = (constraints.maxWidth * 0.48).clamp(minButtonWidth, maxButtonWidth);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      'R\$${precoTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.laranja,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minButtonWidth,
                      maxWidth: buttonWidth,
                    ),
                    child: ElevatedButton.icon(
                      onPressed: onAdicionar,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'ADICIONAR',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.laranja,
                        foregroundColor: AppColors.preto,
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth < 350 ? 4 : 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
