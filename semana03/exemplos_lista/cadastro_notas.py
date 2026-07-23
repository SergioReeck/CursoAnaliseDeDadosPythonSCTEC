# Cadastro de notas

notas = [0, 0, 0, 0, 0]

# Cadastro inicial
for i in range(5):
    notas[i] = float(input(f"Informe a nota {i+1}: "))

while True:
    print("\n===== MENU =====")
    print("1 - Listar todas as notas")
    print("2 - Consultar uma nota")
    print("3 - Alterar uma nota")
    print("4 - Calcular média")
    print("0 - Sair")

    opcao = int(input("Escolha uma opção: "))

    if opcao == 1:
        for i in range(len(notas)):
            print(f"Nota {i+1}: {notas[i]:.2f}")

    elif opcao == 2:
        indice = int(input("Qual nota você deseja consultar (1 a 5)? "))
        print(f"Nota {indice}: {notas[indice - 1]:.2f}")

    elif opcao == 3:
        indice = int(input("Qual nota você deseja alterar (1 a 5)? "))
        nova = float(input("Digite a nova nota: "))
        notas[indice - 1] = nova
        print("Nota alterada com sucesso!")

    elif opcao == 4:
        media = sum(notas) / len(notas)
        print(f"Média: {media:.2f}")

    elif opcao == 0:
        print("Programa encerrado.")
        break

    else:
        print("Opção inválida!")