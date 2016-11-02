class Global_DelayManagerTest < RTeste::Teste
  before do
    @global_delay_manager = Global_DelayManager.new
  end
=begin
  isso "Deve ter exibir uma mensagem após 1 segundo" do
    current_time = Time.new

    6000000.times do
      @global_delay_manager.update
    end

    current_time_more_1_sec = current_time + 1
    afirmar_igualdade current_time_more_1_sec,  @global_delay_manager.current_time
  end
=end

end