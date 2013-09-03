class CustomersController < ApplicationController
require "open-uri"
require "json"
require "digest/md5"
  # GET /customers
  # GET /customers.json
  def index
    #@customers = Customer.page(params[:page])
    @province=Province.all
    @customers=Customer.where("province_id=#{Province.first.id}").page(params[:page])
  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to action: "index", notice: 'Customer was successfully created.' }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to action:"index", notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end


#    def  loaddata
#       @customers=Customer.all

#        @customers.each do |cus|
       
#          url="http://api.map.baidu.com/geocoder/v2/?ak=9fa042b62dac3a4716a35b5faa552a8c&output=json&address=#{address}
# &city=杭州市"
#          urls=URI.encode(url)
#          jsonstext=open(urls).read
#          jsons=JSON.parse(jsonstext)
              
#          if jsons["result"]==nil || jsons["result"].length==0
#              lngs=10
#             lats=10
#            else
#               lngs=jsons['result']['location']['lng']
#               lats=jsons['result']['location']['lat']
           
#          end
#              cus.lng=lngs
#              cus.lat=lats
#              cus.save
#         end 
#           redirect_to  action: "index"
      

#     end

      def searchdata
        cityid=params[:city]
        citys=Province.find(cityid)

  url="http://api.map.baidu.com/geocoder/v2/?ak=9fa042b62dac3a4716a35b5faa552a8c&output=json&address=#{params[:address]}
&city=#{citys}"
         urls=URI.encode(url)
         jsonstext=open(urls).read
         jsons=JSON.parse(jsonstext)
         if jsons['result']==nil ||jsons['result'].length==0
            lngs=10
            lats=10
         else
              
              lngs=jsons['result']['location']['lng']
              lats=jsons['result']['location']['lat']
             
          end 
             address="#{lngs},#{lats}"
              # address<<lngs
              # address<<lats
              render:text=>address
       end

       # taobaoapi
      def trade
           time1=DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d+%H:%M:%S").to_s 
           time2=DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d %H:%M:%S").to_s
            h=Hash.new
            h["app_key"]="21600644"
            h["fields"]="nick"
            h["format"]="json"
            h["method"]="taobao.trades.sold.get"
            h["session"]="6100f1450d3c9e619846611ede121b7f67b78737a60d85a684069607"
            h["sign_method"]="md5"
            h["timestamp"]="#{time1}"
            h["v"]="2.0"
  
            signurl=""
            h.each do |key,value|
            signurl=signurl+"#{key}#{value}"

            end
            @signurl="c650c476a74b7f27ebbc841298afa26b".upcase+signurl+"c650c476a74b7f27ebbc841298afa26b".upcase
            #signurl="c650c476a74b7f27ebbc841298afa26b"+signurl+"c650c476a74b7f27ebbc841298afa26b"
            @sign=Digest::MD5.hexdigest(@signurl).upcase
            @time1=time1.gsub(":","%3A")
            # sgin="jsonformattaobao.trades.sold.getmethodmd5sign_method21601845app_key2.0vtestsession#{time1}timestampnick,user_idfields"
            @urls="http://gw.api.taobao.com/router/rest?sign=#{@sign.upcase}&timestamp=#{@time1}&v=2.0&app_key=21600644&method=taobao.trades.sold.get&partner_id=top-apitools&session=6100f1450d3c9e619846611ede121b7f67b78737a60d85a684069607&format=json&fields=nick" 
            ##{time1.gsub(':','%3A')}
            jsons=open(@urls).read
            # @urlss=URI.escape(@urls)
            render:text=>jsons
      end
      def searchcity
      
       # if params[:city]==nil
       #  @customers=Customer.where("province_id=2").page(params[:page])
       # else
        @customers=Customer.where("province_id=#{params[:city]}").page(params[:page])  
        # end 
        @province=Province.all
        render :action=>"index"
        
      end
end
