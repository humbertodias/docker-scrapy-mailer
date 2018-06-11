import scrapy

# REQUIREMENTS
# pip install scrapy

# run it
# scrapy runspider senac.py -o senac.json

class SenacVagas(scrapy.Spider):
    name = 'SenacVagas'
    host = 'http://www.sp.senac.br/recru/portal/'
    start_urls = [host + '_display.jsp']

    def parse(self, response):
        listAHref = response.xpath("//span[contains(@id,'codVaga')]/..")
        for i in range(0, len(listAHref)):
            aHref = self.host
            spans = listAHref[i].xpath("span")
            titVaga = spans[0].xpath("text()").extract_first().strip()
            codVaga = spans[1].xpath("text()").extract_first().strip()
            codigo  = codVaga.split("-")[0].strip()
            vagas = codVaga.split("-")[1].strip().split()[0]
            cargo = titVaga

            divLocal = listAHref[i].xpath("../div[2]")
            local = divLocal.xpath("text()")[-1].extract().strip()
            yield { "codigo" : codigo, "cargo": cargo, "vagas": vagas, "href": aHref, "local": local }
