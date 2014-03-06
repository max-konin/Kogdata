$.ajax({
  url: '/cities.json',
  dataType : "json",
  success: function(data) {
    data = JSON.parse(data.div_contents.body);
    var city_list = []
    $.each(data, function(i,obj){
      city_list.push(obj.name)
    });
    window.city = city_list
//    console.log(city_list)
    }
})
