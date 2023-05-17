require "rails_helper"

describe "Usuário favorita um lote" do
  it "e visualiza os lotes favoritados com sucesso" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")
    first_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    second_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "14367226085", password: "123123")
    category = Category.create!(name: "Eletrônicos")
    first_product = ProductModel.create!(
      name: "Monitor LG",
      description: "Monitor de 24 polegadas da marca LG...",
      weight: 1500,
      width: 100,
      height: 80,
      depth: 15,
      category: category,
    )
    second_product = ProductModel.create!(
      name: "Smartphone Samsung",
      description: "Smartphone Samsung s21...",
      weight: 1000,
      width: 100,
      height: 50,
      depth: 5,
      category: category,
    )
    first_lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 1.day.from_now,
      min_value: 1200,
      min_allowed_difference: 35,
      register_by_id: first_admin.id,
      approved_by_id: second_admin.id,
    )
    second_lot = Lot.create!(
      batch_code: "HZK119066",
      start_date: 1.minute.from_now,
      end_date: 1.day.from_now,
      min_value: 2500,
      min_allowed_difference: 100,
      register_by_id: second_admin.id,
      approved_by_id: first_admin.id,
    )
    first_lot.product_models << first_product
    second_lot.product_models << second_product

    travel_to 1.hour.from_now do
      first_lot.update(status: :approved)
      second_lot.update(status: :approved)

      login_as(user)
      visit root_path
      all(".favorite")[0].click

      expect(current_path).to eq favorites_path
      expect(page).to have_content "Lote foi adicionado aos favoritos."
      expect(page).to have_content "Lote: EOR661430"
      expect(page).to have_content "R$ 1.200,00"
      expect(user.favorites.exists?(lot_id: first_lot.id)).to be true
      expect(page).not_to have_content "Lote: HZK119066"
      expect(page).not_to have_content "R$ 2.500,00"
      expect(user.favorites.exists?(lot_id: second_lot.id)).to be false
    end
  end

  it "e desmarca um lote dos favoritos com sucesso" do
    user = User.create!(email: "felipe@gmail.com.br", cpf: "81140180037", password: "123123")
    first_admin = User.create!(email: "maria@leilaodogalpao.com.br", cpf: "03507869098", password: "123123")
    second_admin = User.create!(email: "felipe@leilaodogalpao.com.br", cpf: "14367226085", password: "123123")
    category = Category.create!(name: "Eletrônicos")
    first_product = ProductModel.create!(
      name: "Monitor LG",
      description: "Monitor de 24 polegadas da marca LG...",
      weight: 1500,
      width: 100,
      height: 80,
      depth: 15,
      category: category,
    )
    second_product = ProductModel.create!(
      name: "Smartphone Samsung",
      description: "Smartphone Samsung s21...",
      weight: 1000,
      width: 100,
      height: 50,
      depth: 5,
      category: category,
    )
    first_lot = Lot.create!(
      batch_code: "EOR661430",
      start_date: 1.minute.from_now,
      end_date: 1.day.from_now,
      min_value: 1200,
      min_allowed_difference: 35,
      register_by_id: first_admin.id,
      approved_by_id: second_admin.id,
    )
    second_lot = Lot.create!(
      batch_code: "HZK119066",
      start_date: 1.minute.from_now,
      end_date: 1.day.from_now,
      min_value: 2500,
      min_allowed_difference: 100,
      register_by_id: second_admin.id,
      approved_by_id: first_admin.id,
    )
    first_lot.product_models << first_product
    second_lot.product_models << second_product

    travel_to 1.hour.from_now do
      first_lot.update(status: :approved)
      second_lot.update(status: :approved)

      login_as(user)
      visit root_path
      all(".favorite")[0].click
      visit root_path
      all(".favorite")[0].click
      all(".favorite")[1].click

      expect(page).to have_content "Lote: HZK119066"
      expect(page).to have_content "R$ 2.500,00"
      expect(user.favorites.exists?(lot_id: second_lot.id)).to be true
      expect(page).not_to have_content "Lote: EOR661430"
      expect(page).not_to have_content "R$ 1.200,00"
      expect(user.favorites.exists?(lot_id: first_lot.id)).to be false
    end
  end
end
