require "rails_helper"

describe "Admin acessa um lote" do
  it "e adiciona um produto" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")

    lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: admin.id,
    )

    category = Category.create!(name: "Eletrônicos")

    product = ProductModel.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Adicionar"

    expect(page).to have_content "O produto foi adicionado com sucesso."
    expect(page).to have_content "Descrição: Caixa de som JBL Xtreme 2 com Bluetooth"
    expect(page).not_to have_button "Adicionar"
  end

  it "e remove um produto" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")

    lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: admin.id,
    )

    category = Category.create!(name: "Eletrônicos")

    product = ProductModel.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    lot.product_models << product
    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Remover"

    expect(page).to have_content "O produto foi removido com sucesso."
    expect(page).not_to have_content "Descrição: Caixa de som JBL Xtreme 2"
  end

  it "e não tem permissão para aprovar o lote que ele registrou" do
    admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")

    lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: admin.id,
    )

    login_as(admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).to have_content "Administrador que aprovou deve ser diferente do admin que cadastrou o lote"
    expect(lot.reload.approved_by).to be nil
  end

  it "e outro admin aprova o lote com sucesso" do
    first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")

    lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: first_admin.id,
    )

    category = Category.create!(name: "Eletrônicos")

    product = ProductModel.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    lot.product_models << product
    login_as(second_admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).to have_content "O lote foi aprovado com sucesso."
    expect(lot.reload.approved_by).to eq second_admin
  end

  it "e não consegue aprovar um lote que já foi aprovado" do
    first_admin = User.create!(email: "Felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    second_admin = User.create!(email: "Maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")

    lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: first_admin.id,
    )

    category = Category.create!(name: "Eletrônicos")

    product = ProductModel.create!(
      name: "Caixa de som JBL",
      description: "Caixa de som JBL Xtreme 2 com Bluetooth e bateria de 10.000 mAh...",
      weight: 2393,
      width: 13,
      height: 28,
      depth: 13,
      category: category,
    )

    lot.product_models << product
    login_as(second_admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).to have_content "O lote já foi aprovado"
    expect(page).to have_content "Criado por: Felipe"
    expect(page).to have_content "Aprovado por: Maria"
  end

  it "e não consegue aprovar um lote que não tem nenhum produto" do
    first_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "75857986010", password: "123123")
    second_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "09468829081", password: "123123")

    lot = Lot.create!(
      start_date: 1.minute.from_now,
      end_date: 2.hours.from_now,
      min_value: 1000,
      min_allowed_difference: 50,
      register_by_id: first_admin.id,
    )

    login_as(second_admin)
    visit root_path
    within "aside" do
      click_on "Lotes"
    end
    click_on "Gerenciar"
    click_on "Aprovar Lote"

    expect(page).not_to have_content "O lote foi aprovado com sucesso."
    expect(page).to have_content "O lote não pode ser aprovado."
    expect(page).to have_content "Produto deve ser incluído para que um lote possa ser aprovado"
  end
end
