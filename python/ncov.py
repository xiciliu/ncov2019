# -*- coding: utf-8 -*-
"""
Created on Wed May 30 17:54:35 2018

@author: xici
"""

import requests
import re
import json,os,shutil
from hyper.contrib import HTTP20Adapter
from bs4 import BeautifulSoup
import js2xml
from lxml import etree

from DB.Mysql import  Mysql
import time,datetime

mysql = Mysql()

thecookies={}
proxies = {
  "http": "http://8.8.8.8:8000",
  "https": "http://8.8.8.8:8000",
}
proxies=None
session=requests.Session()

def download(url,dir,name):
    print("downloading with requests ",url)
    #print(thecookies)
    if len(name.split('.'))<=1:
        space=url.split('.')
        if len(space)>1:
            prefix=space[len(space)-1]
            name=name+'.'+prefix
    print(dir+name)
    if not os.path.exists(dir+name):
        r = requests.get(url,proxies=proxies,verify=False) 
        with open(dir+name, "wb") as code:
            code.write(r.content)
    else:
        print('skip down due to existance')

def getInfo(url):
    res=requests.get(url,proxies=proxies,verify=False)
    html=str(res.content,'UTF-8')
    return html
def analyze(html):
    soup = BeautifulSoup(html, 'lxml')
    #handleCountv2(soup)
    handleNotice(soup)
    
def handleNotice(soup):
    print('handleNotice')
    script = soup.find_all('script',{'id':'getTimelineService'})[0]
    src=script.get_text()
    #print(src)
    flag='window.getTimelineService ='
    if flag in src:
        pos=src.index(flag)
        src=src[pos+len(flag):]
    
    flag='}catch(e){}'
    if flag in src:
        pos=src.index(flag)
        src=src[:pos]
    
    datalist=json.loads(src)
    #print(datalist)
    #print(type(datalist))
    if isinstance(datalist,list):
        pass
    else:
        datalist=datalist['result']
    #print(len(datalist))
    for data in datalist:
        record={}
        record['sourceid']=data['id']
        record['provincetext']='unknown'
        if 'provinceName' in data:
            record['provincetext']=data['provinceName'].replace('省','').replace('自治区','').replace('市','').replace('壮族自治区','').replace('维吾尔族自治区','').replace('回族自治区','')
        record['timeset']=data['pubDate']
        record['pubDateStr']='pubDateStr'
        record['title']=data['title']
        record['detail']=data['summary']
        record['source']=data['infoSource']
        record['url']=data['sourceUrl']
        
        #print(record)
        #save
        db_recorddata=mysql.getOne('select * from record where sourceid=%s',[record['sourceid']])
        if db_recorddata:
            pass
        else:
            #print('insert one')
            #print('insert into record(province,timeset,title,detail,source,url,sourceid) values(%s,%s,%s,%s,%s,%s,%s)'%(record['provincetext'],getTime(int(record['timeset'])/1000),record['title'],record['detail'],record['source'],record['url'],record['sourceid']))
            
            db_id=mysql.insertOne('insert into record(province,timeset,title,detail,source,url,sourceid) values(%s,%s,%s,%s,%s,%s,%s)', [record['provincetext'],getTime(int(record['timeset'])/1000),record['title'],record['detail'],record['source'],record['url'],record['sourceid']])
            #db_id=mysql.insertOne('insert into record(province,timeset,title,detail,source) values(%s,%s,%s,%s,%s,%s,%s,%s)', [record['provincetext'],getTime(int(record['timeset'])/1000),record['title'],record['detail'],,record['source'],record['url'],record['sourceid']])
            mysql.end()
        #break

#str=getTime(1552267863)
def getTime(seconds):
    timeArray = time.localtime(seconds)
    otherStyleTime = time.strftime("%Y-%m-%d %H:%M:%S", timeArray)
    #print(otherStyleTime)
    return otherStyleTime
    
#time = composeTime("2019_03_06 17:07:38")
def composeTime(time1):
    time2 = datetime.datetime.strptime(time1, "%Y_%m_%d %H:%M:%S")
    time3 = time.mktime(time2.timetuple())
    time4 = int(time3)
    return time4

def handleCount(soup):
    #从html的div入手
    #content=soup.select('div[class="tab2___PhOZ6"] > div[class="block___wqUAz"]')
    #print(len(content))
    #for case in content:
    #    pass
        
    #scripts = soup.find_all('script',{'id':'getListByCountryTypeService1'})
    #print(len(scripts))
    script = soup.find_all('script',{'id':'getListByCountryTypeService1'})[0]
    src=script.get_text()
    #print(src)
    flag='window.getListByCountryTypeService1 ='
    if flag in src:
        pos=src.index(flag)
        src=src[pos+len(flag):]
    
    flag='}catch(e){}'
    if flag in src:
        pos=src.index(flag)
        src=src[:pos]
    listprovince=json.loads(src)
    print(len(listprovince))
    for province in listprovince:
        record={}
        record['provincetext']=province['provinceShortName']
        record['totalconfirm']=0
        record['totalsuspect']=0
        record['totaldead']=0
        record['totalcure']=0
        confirmcount=0
        suspectcout=0
        deadcount=0
        curecount=0
        print(record['provincetext'])
        str=province['tags']
        regex=re.compile(r'确诊\s*(\d+)\s*例')
        m=regex.search(str)
        if m:
            confirmcount=m.group(1)
            record['totalconfirm']=confirmcount
            
        regex=re.compile(r'疑似\s*(\d+)\s*例')
        m=regex.search(str)
        if m:
            suspectcout=m.group(1)
            record['totalsuspect']=suspectcout
            
        regex=re.compile(r'死亡\s*(\d+)\s*例')
        m=regex.search(str)
        if m:
            deadcount=m.group(1)
            record['totaldead']=deadcount
        
        regex=re.compile(r'治愈\s*(\d+)\s*例')
        m=regex.search(str)
        if m:
            curecount=m.group(1)
            record['totalcure']=curecount
        
        print(record)
        #save
        db_id=mysql.update('update province set totalconfirm=%s,totalsuspect=%s,totaldead=%s,totalcure=%s where provincetext=%s', [record['totalconfirm'],record['totalsuspect'],record['totaldead'],record['totalcure'],record['provincetext']])
        mysql.end()
        
            
    #method 1
    #listprovince=json.loads(script.get_text())
    #print(listprovince)
    
    #method 2
    #src_text = js2xml.parse(src,  debug=False)
    #src_tree = js2xml.pretty_print(src_text)
    #print('treeeeeeeeeeeeeeeeeeeeeeeeeeeee')
    #print(src_tree)
    #selector = etree.HTML(src_tree)
    # print(selector)
    #自己去匹配自己想要的数据
    #content = selector.xpath("//property[@name = '_id']/string/text()")[0]
    #print(content)
    
def handleCountv2(soup):
    print('handleCountv2')
    #window.getAreaStat 
    script = soup.find_all('script',{'id':'getAreaStat'})[0]
    src=script.get_text()
    #print(src)
    flag='window.getAreaStat ='
    if flag in src:
        pos=src.index(flag)
        src=src[pos+len(flag):]
    
    flag='}catch(e){}'
    if flag in src:
        pos=src.index(flag)
        src=src[:pos]
    listprovince=json.loads(src)
    print(len(listprovince))
    for province in listprovince:
        record={}
        record['provincetext']=province['provinceShortName']
        record['totalconfirm']=0
        record['totalsuspect']=0
        record['totaldead']=0
        record['totalcure']=0
        confirmcount=0
        suspectcout=0
        deadcount=0
        curecount=0
        #print(record['provincetext'])
        
        record['totalconfirm']=province['confirmedCount']
        record['totalsuspect']=province['suspectedCount']
        record['totaldead']=province['deadCount']
        record['totalcure']=province['curedCount']
        
        #print(record)
        #save
        db_id=mysql.update('update province set totalconfirm=%s,totalsuspect=%s,totaldead=%s,totalcure=%s where provincetext=%s', [record['totalconfirm'],record['totalsuspect'],record['totaldead'],record['totalcure'],record['provincetext']])
        mysql.end()
    

def test():
    html=''
    with open('s.html', "r",encoding='utf-8') as f:
        html=f.read()
    if len(html)>0:
        analyze(html)
        
def main():
    url='https://3g.dxy.cn/newh5/view/pneumonia?from=singlemessage&isappinstalled=0'
    while(True):
        print('running ... %s'%datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
        analyze(getInfo(url))
        time.sleep(60)
    
#test()
main()






