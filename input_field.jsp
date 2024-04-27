<%@ page import="java.util.UUID,java.lang.System" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String[] attributes = {"accept", "autocomplete", "autofocus", "checked", "class", "disabled", "name", "placeholder", "readonly", "required", "size", "style", "tabindex", "type", "value", "accesskey", "autocapitalize", "capture", "contentEditable", "contextMenu", "dirname", "elementtiming", "for", "formenctype", "formmethod", "inputmode", "is", "itemid", "itemprop", "itemref", "itemscope", "itemtype", "lang", "maxlength", "minlength", "multiple", "pattern", "rel", "spellcheck", "step", "title", "translate", "virtualkeyboardpolicy"};
    
    		
    StringBuilder inputAttributes = new StringBuilder();
    for (String attribute : attributes) {
        String value = request.getParameter(attribute);
        if (value != null) {
            inputAttributes.append(" ").append(attribute).append("=\"").append(value).append("\"");
        }
    }


    // Add the id attribute
    String id = request.getParameter("id");
    if (id == null) {
            // Generate a unique ID for this inclusion
            String uniqueId = UUID.randomUUID().toString() + "-" + System.currentTimeMillis();
            id = uniqueId.replace("-", ""); // Set a default value if id is not provided
    }
 // Add the language attribute
    String lang = request.getParameter("lang");
    if(lang == null || lang == "") {
    	lang = "ja";
    }
 
    // Add the stopTimer attribute
    String stopTimer = request.getParameter("stopTimer");
    if(stopTimer == null || stopTimer == "") {
    	stopTimer = "30";
    }
    
    String buttonClass = request.getParameter("buttonClass");
    if(buttonClass == null || buttonClass == "") {
    	buttonClass = "";
    }
    
    String buttonStyle = request.getParameter("buttonStyle");
    if(buttonStyle == null || buttonStyle == "") {
    	buttonStyle = "";
    }
    
    String micIconIdle = request.getParameter("micIconIdle");
    if(micIconIdle == null || micIconIdle == "") {
    	micIconIdle = "voice_input/assets/microphone-solid.svg";
    }
    
    String micIconRecording = request.getParameter("micIconRecording");
    if(micIconRecording == null || micIconRecording == "") {
    	micIconRecording = "voice_input/assets/microphone-solid-white.svg";
    }
 
%>

<!-- Change User Interface (UI) but not the ID -->

<span style="display: inline-flex; align-items: center; gap: 2px;">
    <input <%= inputAttributes.toString() %> id="output_<%= id %>" />
    <button class="<%= buttonClass %>" style="display: inline-flex; justify-content: center; align-items: center;  height: 25px; width: 40px; <%= buttonStyle %>;" id="record_<%= id %>">
		    <img style="object-fit: contain; display: block; height: 100%; " src="<%= micIconIdle %>" alt="microphone"/>
		</button>
</span>
<!-- UI ends here -->

<script>
// [Mandatory] - Initialized the voice recorder
    const recorder_<%= id %> = new VoiceInput($("#output_<%= id %>"), "<%= lang %>", "<%= stopTimer %>"); 

    // [MANDATORY] - to call the startOrStopTranscription() 
    function recordNow_<%= id %>() {
            recorder_<%= id %>.startOrStopTranscription()
    }

    // Change the logic as needed
     function whileRecording_<%= id %>() {
       $("#record_<%= id %>").empty();
       $("#record_<%= id %>").append('<img style="object-fit: contain; display: block; height: 100%;" src="<%= micIconRecording %>" alt="microphone"/>');
        $("#record_<%= id %>").css("background-color", "red")
      //  $("#record_<%= id %>").css("color", "white")
    }

    // change the logic as needed
    function whenRecordingFinished_<%= id %>() {
    	 $("#record_<%= id %>").empty();
         $("#record_<%= id %>").append('<img style="object-fit: contain; display: block; height: 100%;" src="<%= micIconIdle %>" alt="microphone"/>');
      
        $("#record_<%= id %>").css("background-color", "white")
      //  $("#record_<%= id %>").css("color", "#333")
    }

    // change the logic as needed
    function whileLoading_<%= id %>() {
        // console.log("Loading")
    }

    // change the logic as needed
    function whenFinished_<%= id %>() {
        // console.log("Finished")
        $("#output_<%= id %>").attr('readonly', false);
    }

    
    // While Recording audio, call the whileRecording function 
    recorder_<%= id %>.on("recordingStarted", whileRecording_<%= id %>)
    // After recording audio stops, call whenRecordingFinished function
    recorder_<%= id %>.on("recordingStopped", whenRecordingFinished_<%= id %>)
    // While converting the recorded audio to text, call whileLoading function
    recorder_<%= id %>.on("isLoading", whileLoading_<%= id %>)
    // When conversion of audio to text is finished, call whenFinished function
    recorder_<%= id %>.on("isFinished", whenFinished_<%= id %>)

    // When the user clicks the mic button start recording by calling the recordNow function
    $("#record_<%= id %>").click(recordNow_<%= id %>);
</script>
