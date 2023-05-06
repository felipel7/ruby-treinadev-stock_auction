require "rails_helper"

describe "Admin registra um novo produto" do
  it "e envia com sucesso" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    Category.create!(name: "Vestuário")
    Category.create!(name: "Eletrônicos")

    login_as(admin)
    visit root_path
    click_on "Produtos"
    click_on "Cadastrar Novo Produto"
    fill_in "Nome", with: "Monitor LG"
    fill_in "Descrição", with: "Monitor de 24 polegadas da marca LG..."
    fill_in "Altura", with: 80
    fill_in "Largura", with: 100
    fill_in "Profundidade", with: 10
    fill_in "Peso", with: 1500
    select "Eletrônicos", from: "Categoria"
    click_on "Cadastrar Novo Produto"

    expect(page).to have_content "O produto foi cadastrado com sucesso"
    expect(page).to have_content "Monitor LG"
    expect(page).to have_content "Dimensões: 100cm x 80cm x 10cm"
    expect(page).to have_content "Categoria: Eletrônicos"
    expect(page).not_to have_content "Vestuário"
  end

  it "e falha quando tem informações incorretas" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    Category.create!(name: "Vestuário")
    Category.create!(name: "Eletrônicos")

    login_as(admin)
    visit root_path
    click_on "Produtos"
    click_on "Cadastrar Novo Produto"
    fill_in "Nome", with: "Monitor LG"
    fill_in "Descrição", with: ""
    fill_in "Altura", with: -80
    fill_in "Largura", with: 0
    fill_in "Profundidade", with: -10
    fill_in "Peso", with: -15
    select "Eletrônicos", from: "Categoria"
    click_on "Cadastrar Novo Produto"

    expect(page).to have_content "Não foi possível cadastrar o produto"
    expect(page).to have_content "Descrição não pode ficar em branco"
    expect(page).to have_content "Peso deve ser maior que 0"
    expect(page).to have_content "Largura deve ser maior que 0"
    expect(page).to have_content "Altura deve ser maior que 0"
    expect(page).to have_content "Profundidade deve ser maior que 0"
  end
end
