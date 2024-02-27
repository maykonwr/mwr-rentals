local Translations = {
    targetlabels = {
        rent_vehicle = 'Aluguel de veículo',
        view_rentals = 'Ver aluguéis'
    },
    progress = {
        preparing = 'Preparando'
    },
    info = {
        available_vehicle = 'Veículos Disponíveis',
        current_rentals = 'Aluguéis atuais',
        return_vehicle = 'Veículo de devolução',
        vehicle_plate = 'Placa',
        vehicle_fuel = 'Combustível',
        vehicle_location = 'Estacionado',
        vehicle_price = 'Preço',
        payment_method = 'Forma de pagamento',
        payment_cash = 'Dinheiro',
        payment_bank = 'Banco',
        time_for_rental = 'Tempo em horas para locação',
        money_received = 'Você recebeu metade do dinheiro de volta'
    },
    error = {
        invalid_rental_spawnpoint = 'Todas as vagas estao ocupadas!',
        invalid_rental_time = 'O tempo de aluguel deve ser maior que 0',
        no_payment_method = 'Nenhuma forma de pagamento selecionada.',
        above_rental_limit = 'Isso está acima do limite de aluguel.',
        no_rental_time = 'Nenhum horário de aluguel selecionado.',
        not_the_right_vehicle = 'Este não é o veículo certo..',
        no_vehicle_nearby = 'Não há veículo por perto..',
        insufficent_funds = 'Você não tem dinheiro suficiente..',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
