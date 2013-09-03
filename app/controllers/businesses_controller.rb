class BusinessesController < ApplicationController
  # GET /businesses
  # GET /businesses.json
  require "json"
  require "open-uri"
  def index
  # @businesses = Business.page(params[:page])
   @province=Province.all
   #   if params[:city]==nil
        @businesses=Business.where("province_id=#{Province.first.id}").page(params[:page])
      # else
      #  @businesses=Business.where("province_id=#{params[:cid]}").page(params[:page])  
      #  end  
      #render :text=>@businesses.id
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @businesses }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @business = Business.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @business }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.json
  def new
    @business = Business.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @business }
    end
  end

  # GET /businesses/1/edit
  def edit
    @business = Business.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = Business.new(params[:business])

    respond_to do |format|
      if @business.save
        format.html { redirect_to action: "index"}
        format.json { render json: @business, status: :created, location: @business }
      else
        format.html { render action: "new" }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.json
  def update
    @business = Business.find(params[:id])

    respond_to do |format|
      if @business.update_attributes(params[:business])
        format.html { redirect_to aciton: "index"}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business = Business.find(params[:id])
    @business.destroy

    respond_to do |format|
      format.html { redirect_to businesses_url }
      format.json { head :no_content }
    end
  end



    # def  loaddata
    #   @business=Business.all

    #    @business.each do |bus|
    #      url="http://api.map.baidu.com/geocoder/v2/?address=#{bus.address}&output=json&ak=E096e61445fddbb55071fc56f78e1002"
    #      urls=URI.encode(url)
    #      jsonstext=open(urls).read
    #      jsons=JSON.parse(jsonstext)
    #      if jsons['result']==nil ||jsons['result'].length==0
    #         ings=10
    #         lats=10
    #      else
    #           ings=jsons['result']['location']['lng']
    #           lats=jsons['result']['location']['lat']
    #           bus.ing=ings
    #           bus.lat=lats       
    #           bus.save
    #       end 
           
    #    end 
    #       redirect_to  action: "index"
      

    # end

       def searchdata
         # citys=["上海市", "杭州市", "金华市", "宁波市", "衢州市", "义乌市", "台州市", "绍兴市", "湖州市", "南通市", "扬州市", "泰州市", "苏州市", "常熟市", "徐州市", "南京市", "张家港市"]
            cityid=params[:city].to_i
            citys=Province.find(cityid)
         url="http://api.map.baidu.com/geocoder/v2/?ak=9fa042b62dac3a4716a35b5faa552a8c&output=json&address=#{params[:address]}
&city=#{citys}"
         urls=URI.encode(url)
         jsonstext=open(urls).read
         jsons=JSON.parse(jsonstext)
         address=""
         if jsons['result']==nil ||jsons['result'].length==0
            ings=10
            lats=10
         else
              
              ings=jsons['result']['location']['lng']
              lats=jsons['result']['location']['lat']
             
          end 
             address="#{ings},#{lats}"
              # address<<ings
              # address<<lats
              render:text=>address
       end

       def findall
        @business=Business.all
        render:json=>@business       
       end
#
    def searchcity
        @province=Province.all
       if params[:city]==nil
        @businesses=Business.where("province_id=#{Province.first.id}").page(params[:page])
       else
        @businesses=Business.where("province_id=#{params[:city]}").page(params[:page])  
        end 
        render :action=>"index"
        #render :json=>@businesses
      end

end
