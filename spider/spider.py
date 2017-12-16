import scrapy

# REQUIREMENTS
# pip install scrapy

# run it
# scrapy runspider senac-vagas.py -o senac-vagas.json

class SenacVagas(scrapy.Spider):
    name = 'SenacVagas'
    host = 'http://www.sp.senac.br/recru/portal/'
    start_urls = [host + '_display.jsp']

    def parse(self, response):
        listAHref = response.xpath("//a[contains(@href,'_display.jsp?app=mural/detalheNovo.jsp')]")
        for i in range(0, len(listAHref), 3):
            aHref  = self.host + listAHref[i].xpath("@href").extract_first().strip()
            codigo = listAHref[i].xpath("./text()").extract_first().strip()
            cargo  = listAHref[i+1].xpath("./text()").extract_first().strip()
            vagas  = int(listAHref[i+2].xpath("./text()").extract_first().strip())
            yield { "codigo" : codigo, "cargo": cargo, "vagas": vagas, "href": aHref }