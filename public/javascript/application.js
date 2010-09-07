$(document).ready(function(){
    $('.search_movies').click(function(){
        $.get('/search/' + $('#query').val(),function(html){
           if(html){
              $('.results').html('');
              $('.results').append("<ul id='cList'></ul>");  
              for(var i=0;i<html.length;i++){
                 $("#cList").append("<li>" +
                "<a href='"+html[i].url+"' target='blank'>" + html[i].title + "</a> - " +
                "<a href='#' data-imdbid='"+html[i].imdbid+"' class='find_details'>"+html[i].imdbid+"</a>" + "<br />" +
                html[i].content + "</li>"); 
              }
           }           
        });
        return false;        
    });
    $('.find_details').live('click',function(){
        $('#imdbid').val($(this).attr('data-imdbid'));
        return false;
    });
});
