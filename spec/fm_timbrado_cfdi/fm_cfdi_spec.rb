require 'spec_helper'

describe FmTimbradoCfdi::FmCfdi do
  describe '#version_3_2?' do
    let(:respuesta_timbrado){File.open('spec/fixtures/respuesta_timbrado_version_3_2.txt').read}
    it "returns true" do
      expect(FmTimbradoCfdi::FmCfdi.new(respuesta_timbrado).is_version_3_2?).to be_truthy
    end
  end # describe '#version_3_2?'

  describe '#version_3_3?' do
    let(:respuesta_timbrado){File.open('spec/fixtures/respuesta_timbrado_version_3_3.txt').read}
    it "returns true" do
      expect(FmTimbradoCfdi::FmCfdi.new(respuesta_timbrado).is_version_3_3?).to be_truthy
    end
  end # describe '#version_3_3?'

end # describe FmTimbradoCfdi::FmCfdi
