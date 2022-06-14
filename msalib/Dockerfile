# OLD : docker build --build-arg GIT_EMAIL=id --build-arg GIT_PASSWD=pw -t msalib .
# NEW : docker build --build-arg GIT_TOKEN=AAAAAAAA -t msalib .
# (포그라운드 실행) docker run -i -t -p 8070:80 --name lib msalib
# (백그라운드 실행) docker run -i -t -d -p 8070:80 --name lib msalib
# nginx config 수정시 재시작 : nginx -s reload

# make github token : github > setting > developer setting > Personal access token > Generate new token
# 권한 : repo 및 read:packages 권한 주기
# 도움말 : https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/

FROM ubuntu:latest

# ARG는 빌드시에만 사용가능하고, ENV는 실제싱행 RUN/CMD에 사용가능
# ARG GIT_EMAIL
# ARG GIT_PASSWD
ARG GIT_TOKEN

# 작업폴더 만들기
RUN mkdir /data
RUN mkdir /data/www

# Install Nginx.
RUN apt-get update
RUN apt-get install -y nginx unzip curl

# Install debug tool
RUN apt-get install -y vim wget telnet

###################################################
# download libs
###################################################
RUN mkdir /data/www/lib
WORKDIR /data/www/lib
# 10. codemirror
RUN wget https://codemirror.net/codemirror.zip
RUN unzip codemirror.zip
RUN rm codemirror.zip
RUN mv codemirror*/ codemirror/
# 20. bootstrap4
RUN wget https://github.com/twbs/bootstrap/releases/download/v4.4.1/bootstrap-4.4.1-dist.zip
RUN unzip bootstrap-4.4.1-dist.zip
RUN rm bootstrap-4.4.1-dist.zip
RUN mv bootstrap-4.4.1-dist/ bootstrap4/
# 30. bootstrap4 jquery3 slim
RUN wget https://code.jquery.com/jquery-3.4.1.min.js
RUN mv jquery-3.4.1.min.js bootstrap4/
# 40. bootstrap4 popper.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js
RUN mv popper.min.js bootstrap4/
# 42. bootstrap table
RUN wget -O bootstrap-table.zip https://github.com/wenzhixin/bootstrap-table/archive/master.zip
RUN unzip bootstrap-table.zip
RUN mv bootstrap-table-master/src/ bootstrap-table/
RUN rm -rf bootstrap-table.zip bootstrap-table-master/
RUN wget -O ./bootstrap-table/bootstrap-table.min.css https://unpkg.com/bootstrap-table@1.15.5/dist/bootstrap-table.min.css
RUN wget -O ./bootstrap-table/bootstrap-table.min.js https://unpkg.com/bootstrap-table@1.15.5/dist/bootstrap-table.min.js
RUN wget -O ./bootstrap-table/locale/bootstrap-table-ko-KR.min.js https://unpkg.com/bootstrap-table@1.15.5/dist/locale/bootstrap-table-ko-KR.min.js
RUN wget -O ./bootstrap-table/extensions/resizable/bootstrap-table-resizable.min.js https://unpkg.com/bootstrap-table@1.15.5/dist/extensions/resizable/bootstrap-table-resizable.min.js
RUN wget -O ./bootstrap-table/jquery.resizableColumns.min.js https://unpkg.com/jquery-resizable-columns@0.2.3/dist/jquery.resizableColumns.min.js


# 44. tableExport
RUN mkdir /data/www/lib/tableExport
RUN wget -O ./tableExport/tableExport.min.js https://github.com/hhurz/tableExport.jquery.plugin/raw/master/tableExport.min.js
RUN wget -O ./tableExport/FileSaver.min.js https://github.com/eligrey/FileSaver.js/raw/master/dist/FileSaver.min.js
RUN wget -O ./tableExport/jspdf.min.js https://github.com/BiggA94/jsPDF/raw/master/dist/jspdf.min.js
RUN wget -O ./tableExport/xlsx.core.min.js https://github.com/hhurz/tableExport.jquery.plugin/raw/master/libs/js-xlsx/xlsx.core.min.js
RUN wget -O ./tableExport/jspdf.plugin.autotable.min.js https://github.com/simonbengtsson/jsPDF-AutoTable/raw/master/dist/jspdf.plugin.autotable.min.js
RUN wget -O ./tableExport/jspdf.plugin.autotable.js https://github.com/simonbengtsson/jsPDF-AutoTable/raw/master/dist/jspdf.plugin.autotable.js


# 50. jquery
RUN mkdir /data/www/lib/jquery

RUN wget -O jquery/jquery-1.12.4.min.js https://code.jquery.com/jquery-1.12.4.min.js
RUN wget -O jquery/jquery-3.4.1.min.js https://code.jquery.com/jquery-3.4.1.min.js
RUN wget -O jquery/jquery-3.5.1.min.js https://code.jquery.com/jquery-3.5.1.min.js

RUN wget -O jquery/jquery-3.4.1.slim.min.js https://code.jquery.com/jquery-3.4.1.slim.min.js

RUN wget https://jqueryui.com/resources/download/jquery-ui-1.12.1.zip
RUN unzip jquery-ui-1.12.1.zip
RUN rm jquery-ui-1.12.1.zip
RUN mv jquery-ui-1.12.1/jquery-ui.min.* jquery/
RUN rm -rf jquery-ui-1.12.1

RUN wget -O jquery/jquery.resizableColumns.min.js https://raw.githubusercontent.com/dobtco/jquery-resizable-columns/gh-pages/dist/jquery.resizableColumns.min.js
RUN wget -O jquery/jquery.resizableColumns.css https://raw.githubusercontent.com/dobtco/jquery-resizable-columns/gh-pages/dist/jquery.resizableColumns.css

RUN wget -O jquery/jquery.multiselect.js https://raw.githubusercontent.com/nobleclem/jQuery-MultiSelect/master/jquery.multiselect.js
RUN wget -O jquery/jquery.multiselect.css https://raw.githubusercontent.com/nobleclem/jQuery-MultiSelect/master/jquery.multiselect.css


RUN wget -O jquery/anyselect.min.js https://raw.githubusercontent.com/zero12a/anyselect/master/dist/anyselect.min.js
RUN wget -O jquery/anyselect.min.css https://raw.githubusercontent.com/zero12a/anyselect/master/dist/anyselect.min.css


# 60. chart.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js
# 70. feather
RUN wget https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.24.1/feather.min.js.map
# 80. hashmap.js
RUN wget https://raw.githubusercontent.com/flesler/hashmap/master/hashmap.js
# 90. jqPropertyGrid
RUN wget https://raw.githubusercontent.com/ValYouW/jqPropertyGrid/master/jqPropertyGrid.js
RUN wget https://raw.githubusercontent.com/ValYouW/jqPropertyGrid/master/jqPropertyGrid.css
# 100. moment.min.js
RUN wget https://momentjs.com/downloads/moment.min.js
# 110. json2.min.js
RUN wget https://cdnjs.cloudflare.com/ajax/libs/json2/20160511/json2.min.js
# 120. uuidv4.js (OLD, 불필요 common.js에 탑재됨)
#RUN wget -O uuidv4.js https://wzrd.in/standalone/uuid%2Fv4@latest
# 121. uuidv4.js (NEW, 불필요 common.js에 탑재됨)
#RUN wget -O uuidv4.min.js https://cdnjs.cloudflare.com/ajax/libs/uuid/8.3.2/uuidv4.min.js

# 130. summernote
RUN mkdir /data/www/lib/summernote
WORKDIR /data/www/lib/summernote
RUN wget -O summernote-dist.zip https://github.com/summernote/summernote/releases/download/v0.8.16/summernote-0.8.16-dist.zip
RUN unzip summernote-dist.zip
RUN rm summernote-dist.zip
# 140. dojo, gridx 

# 150. cleave.js
WORKDIR /data/www/lib/
RUN wget -O cleave.min.js https://cdn.jsdelivr.net/npm/cleave.js@1.5.4/dist/cleave.min.js

# 160. signature_pad
RUN wget -O signature_pad.min.js https://cdn.jsdelivr.net/npm/signature_pad@2.3.2/dist/signature_pad.min.js

# 170. excel import
RUN wget -O xlsx.full.min.js https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.2/xlsx.full.min.js

# 180. fontawesome (vuetify)
RUN mkdir fontawesome
RUN mkdir fontawesome/css
RUN mkdir fontawesome/webfonts
RUN wget -O fontawesome/css/fontawesome.css https://use.fontawesome.com/releases/v5.0.13/css/all.css
RUN wget -O fontawesome/webfonts/fa-solid-900.woff2 https://use.fontawesome.com/releases/v5.0.13/webfonts/fa-solid-900.woff2
RUN wget -O fontawesome/webfonts/fa-solid-900.woff https://use.fontawesome.com/releases/v5.0.13/webfonts/fa-solid-900.woff

# 190. materialdesignicons (vuetify)
RUN mkdir materialdesignicons
RUN mkdir materialdesignicons/css
RUN mkdir materialdesignicons/fonts
RUN wget -O materialdesignicons/css/materialdesignicons.min.css https://cdn.jsdelivr.net/npm/@mdi/font@5.x/css/materialdesignicons.min.css
RUN wget -O materialdesignicons/fonts/materialdesignicons-webfont.woff2 https://cdn.jsdelivr.net/npm/@mdi/font@5.x/fonts/materialdesignicons-webfont.woff2?v=5.3.45
RUN wget -O materialdesignicons/fonts/materialdesignicons-webfont.eot https://cdn.jsdelivr.net/npm/@mdi/font@5.x/fonts/materialdesignicons-webfont.eot

# 191. vue & vuetify
RUN wget -O vue2x.js https://cdn.jsdelivr.net/npm/vue@2.x/dist/vue.js
RUN wget -O vuetify2x.js https://cdn.jsdelivr.net/npm/vuetify@2.x/dist/vuetify.js

RUN wget -O vue2x.min.js https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.min.js
RUN wget -O vuetify2x.min.js https://cdn.jsdelivr.net/npm/vuetify@2.5.3/dist/vuetify.min.js
RUN wget -O vuetify2x.min.css https://cdn.jsdelivr.net/npm/vuetify@2.5.3/dist/vuetify.min.css



# 192. jodit
RUN wget -O jodit.min.js https://cdnjs.cloudflare.com/ajax/libs/jodit/3.4.22/jodit.min.js
RUN wget -O jodit.min.css https://cdnjs.cloudflare.com/ajax/libs/jodit/3.4.22/jodit.min.css

# 193. select2 (multi tag select)
RUN wget -O jquery/select2.min.css https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css
RUN wget -O jquery/select2.min.js https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js

# 194. lodash
RUN wget -O lodash.min.js https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js

# 195. toastr
RUN wget -O toastr.min.js https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js
RUN wget -O toastr.min.css https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css

# 196. split.min.js
RUN wget -O split.min.js https://cdnjs.cloudflare.com/ajax/libs/split.js/1.6.2/split.min.js



# 200. (private project) dhtmlx lib
RUN mkdir /data/www/lib/dhtmlxSuite
WORKDIR /data/www/lib/dhtmlxSuite

# NEW github Auth (naver xbox에서 down해야함)
#RUN echo -H "Authorization: token ${GIT_TOKEN}" https://raw.githubusercontent.com/zero12a/lib/master/dhtmlxSuite_v461_pro.zip --output dhtmlx.zip
#RUN curl -H "Authorization: token ${GIT_TOKEN}"  https://raw.githubusercontent.com/zero12a/lib/master/dhtmlxSuite_v461_pro.zip --output dhtmlx.zip
#RUN unzip dhtmlx.zip

# 300. (img, "-L옵션은 리다이렉트처리")
WORKDIR /data/www/
RUN curl -L -o img.zip -H "Authorization: token ${GIT_TOKEN}"  https://github.com/zero12a/img/archive/master.zip 
RUN unzip img.zip
RUN mv img-master img/
RUN rm img.zip

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# conf copy
WORKDIR /etc/nginx/
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msalib/nginx.conf.tmpl


# conf make conf
ENTRYPOINT [ \
    "render", \
        "/etc/nginx/nginx.conf", \
        "--" \
]

RUN chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/data/www"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80 443
