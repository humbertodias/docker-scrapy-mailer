# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import scrapy
from scrapy.linkextractor import LinkExtractor
from scrapy.spiders import Rule, CrawlSpider

# REQUIREMENTS
# pip install scrapy

# run it
# scrapy runspider jnj.py -o jnj.json

class JNJVagas(scrapy.Spider):
    name = 'JnJVagas'
    start_urls = ['https://jobs.jnj.com/api/jobs']
    
    # Method for parsing items
    def parse(self, response):
        import json
        json_ascii   = response.body.decode('ascii', 'ignore')
        jsonresponse = json.loads(json_ascii)
        for job in jsonresponse['jobs']:
            data = job['data']
            codigo = data['slug']
            cargo  = data['title']
            vagas  = data['meta_data']['job_grade']
            aHref  = data['apply_url']
            local  = data['full_location']

            yield { "codigo" : codigo, "cargo": cargo, "vagas": vagas, "href": aHref, "local": local }
