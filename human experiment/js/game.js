var w = window.innerWidth;
var h = window.innerHeight;
var min_width = 1258; 
var min_height = 630; 

//window.cond = Math.floor((Math.random() * 3 ) + 1);
//window.cond =1; // Math.floor((Math.random() * 3 ) + 1);
window.cond =Math.floor((Math.random() * 6 ) + 1);

window.worker_ID = getQueryVariable("MID");

if(!window.worker_ID) {
  window.worker_ID = "lab"; 
  window.prev_player = null; 
} else {
           $.ajax({ 
             url: "checkPrevSubject.php",
               data: {"ID": window.worker_ID}, 
                type: "POST",
                async: false,
                    success: function(data) {
                      var clbk = JSON.parse(data); 
                      // window.worker_ID = clbk['id'];
                      window.prev_player = clbk['prev_player']; 
                    }
              });
}

$(document).ready(function() {
window.nTrials =30; // 30; 
// shuffle the images order
var trial_vec = new Array();
for (i=0; i<window.nTrials;i++){ trial_vec[i]=i+1;}
window.im_order =trial_vec; // shuffle(trial_vec);
window.curr_trial = 1; 
$("#start_button").click(function() {
    // Initialize the game 
      gender =document.forms["details"]["gender"].value; 
      yearOfBirth = document.forms["details"]["birthYear"].value;
    var date = new Date();//Thu Jul 26 2012 15:59:09 GMT+0400 ..
    window.beg_date=date.toString().replace(/^[^\s]+\s([^\s]+)\s([^\s]+)\s([^\s]+)\s([^\s]+)\s.*$/ig,'$3-$1-$2 $4');
    $.ajax({ 
    url: "initialize_game.php",
                 data: {"gender": gender, "birthYear": yearOfBirth,"ID": window.worker_ID,"begDate": window.beg_date,"condition": window.cond}, 
                    type: "POST",
                    async: false,
                        success: function(data) {
                            var clbk = JSON.parse(data); 
                            window.worker_ID = clbk['id'];
                            window.code = clbk['code']; 
                        }
            });

$("#trial_inst").css("display", "block"); 
$("#start_button").css("display","none"); 
$("#pers_details").css("display","none");
$("#inst").css("display","none"); 

});

  dialog_replay = $("#dialog-replay").dialog({
    dialogClass: 'no-close',
    autoOpen:false,
    height:250,
    width: 550,
    modal: true
  });

 dialogempty = $("#dialog_empty").dialog({
    autoOpen:false,
    height:330,
    width: 550,
    modal: true,
    buttons: { Continue : function() {
      $( this ).dialog( "close" );

    }}
  });

if(typeof(window.prev_player) =="string") {
// open a dialog that this is a previous player: 
dialog_replay.dialog("open"); 
};

$("#start_trial").click( function () {
  $("#trial_inst").css("display","none"); 
  document.body.style.cursor = 'none';
  start_game(window.curr_trial,window.im_order); 
  });

$("#submit_ans").click( function() { 
// Send to server the answer + move on to the next trial 
  curr_ans =document.forms["quest"]["txt_box"].value; 
    if(curr_ans.length === 0 || !curr_ans.trim()) { 
        document.body.style.cursor = 'auto';
        dialogempty.dialog("open");
      } else {
    curr_im_idx = window.im_order[window.curr_trial-1]; 
    var d = new Date(); 
    var currTime = d.getTime();   
    iti = (1/1000)*(currTime-window.beg_time);   
    var jsonString = {"code": window.code, "condition": window.cond ,"subAnswer": curr_ans, "ITI": iti ,"im_idx": curr_im_idx ,"trial_idx": window.curr_trial}; 
    $.ajax({ 
        url: "save_subject_answer.php",
        data: jsonString, 
        type: "GET",
        async: false
          })
    // Move on to the next trial.. (for now immediatly - maybe we will add another button )
    window.curr_trial =parseInt(document.getElementById("tr_num_train").innerHTML) + 1;  
    // Check if there is another trial or to finish and give the code : 
    if (window.curr_trial>window.nTrials) { 
        // finish the game 
      document.getElementById("mturk_code").innerHTML = window.code; 
      document.getElementById("tit").innerHTML = "Thank you for your participation!";   
      $("#subject_ans").css("display","none"); 
       document.body.style.cursor = 'auto';
    
     $("#finish_frame").css("display","block"); 
    // pos = $("#the_code").position(); 
    // x_cor = pos.left; 
    //  $("#mturk_code").css({"left": x_cor});
    //  $("#cheer_im").css({"left": x_cor});
        } else {
      document.getElementById("tr_num_train").innerHTML = window.curr_trial ;
      $("#subject_ans").css("display","none"); 
      $("#trial_inst").css("display","block");
     $("#fixation").css("display","none"); 
      document.body.style.cursor = 'auto';
    document.forms["quest"]["txt_box"].value = ""; 
    // document.getElementById("txt_box_content").focus();
   // start_game(window.curr_trial,window.im_order); 
        }
};


}); 
});
function start_game(trial_i,im_order) { 
$("#fixation").css("display","block"); 
// Change the source of the image to show
document.getElementById("mix_im").src = "img/"+window.cond +"/"+ im_order[trial_i-1] + ".JPEG";
setTimeout(function() {showImage(); },2000); 
}

function showImage() { 

 $("#fixation").css("display","none"); 
       d = new Date(); 
       window.beg_time = d.getTime();  
$("#mix_im").show(); 
	setTimeout(function() { 
		$("#mix_im").hide(); 
		$("#subject_ans").css("display","block"); 
    document.getElementById("txt_box_content").focus();

		$("#trial_inst").css("display","none"); 

	       d = new Date(); 
    	   window.end_time = d.getTime();  
	 	window.time_of_split = (1/1000)*( window.end_time-window.beg_time);    
		},100)
}

function shuffle(arr)
{ 
for(var j, x, i = arr.length; i; j = parseInt(Math.random() * i), x = arr[--i], arr[i] = arr[j], arr[j] = x);
return arr;
};

 function getQueryVariable(variable)
{
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
       }
       return(false);
}
