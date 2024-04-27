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

    String selected = request.getParameter("selected");
    if(selected == null || selected == "") {
    	selected = "";
    }
    
    String placeholder = request.getParameter("placeholder");
    
    String name = request.getParameter("name");
    
    String options = request.getParameter("options");
    if(options == null) {
        options = "";
    }
    String[] optionsArr = options.split("[,，]");

 
%>

<!-- Change User Interface (UI) but not the ID -->

<span style="display: inline-flex; align-items: center; gap: 2px;">
    <!--  <input <%= inputAttributes.toString() %> id="select_output_<%= id %>" />  -->
	    <select id="select_output_<%= id %>" name="<%= name %>" <%= inputAttributes.toString() %>>
	        <option selected value="" disabled="disabled"><%= (placeholder != null && placeholder != "") ? placeholder : "選択する"  %></option>
	        <% for (String option : optionsArr) { %>
                <% if(selected != null && selected.equals(option)) { %>
	                <option selected value="<%= option %>"><%= option %></option>
                <% } else { %>
	                <option value="<%= option %>"><%= option %></option>
                <% }  %>
	        <% } %>
	    </select>
	    
	    <button class="<%= buttonClass %>" style="display: inline-flex; justify-content: center; align-items: center;  height: 25px; width: 40px; <%= buttonStyle %>;" id="select_record_<%= id %>">
		    <img style="object-fit: contain; display: block; height: 100%; " src="<%= micIconIdle %>" alt="microphone"/>
		</button>

		
	    <div style="color:red; display: none" id="select_errorMessageArea_<%= id %>"></div>
</span>
<!-- UI ends here -->

<script>
// [Mandatory] - Initialized the voice recorder
    // ! const select_recorder_<%= id %> = new VoiceInput($("#select_output_<%= id %>"), "<%= lang %>", "<%= stopTimer %>"); 
	const select_recorder_<%= id %> = new VoiceInput("", "<%= lang %>", "<%= stopTimer %>");
	
	const selectionOption_<%= id %> = document.getElementById("select_output_<%= id %>");
	const select_errorMessageArea_<%= id %> = document.getElementById("select_errorMessageArea_<%= id %>");

    // [MANDATORY] - to call the startOrStopTranscription() 
    async function select_recordNow_<%= id %>() {
        try {
                const result = await select_recorder_<%= id %>.startOrStopTranscription(true);
                const array = '<%= options %>'.split(",")
                
                
                const event = new CustomEvent("<%= id %>", {detail: {text: result}})
                document.dispatchEvent(event)
                
                
                if(result) {
                    const foundIndex = array.findIndex(item => {
                        const itemLowerCase = item.toLowerCase().replace(/[.。!\s]/g, "")
                        const resultLowerCase = result.toLowerCase().replace(/[.。!\s]/g, "")

                        return itemLowerCase === resultLowerCase;
                    });
                    
                    if(foundIndex !== -1) {
                        selectionOption_<%= id %>.selectedIndex = foundIndex + 1;	
                        //if(select_errorMessageArea_<%= id %>.style.display === 'block'){
                        //	select_errorMessageArea_<%= id %>.style.display = 'none'
                        //}
                    }else {
                        selectionOption_<%= id %>.selectedIndex = 0;
                        //errorMessageArea.textContent = 'No match found. Try again!'
                        //errorMessageArea.style.display = 'block'
                        const errorMessage = "[ "+result+" ]\nNo match found. Try again! \n [ "+result+" ]\n一致するものが見つかりませんでした。もう一度試してください。"
                        window.alert(errorMessage)
                    }
                }
                else {
                    console.log('Not found')
                }
        } catch(err) {
            console.log(err)
            selectionOption_<%= id %>.disabled = false;
        }
  
    }

    // Change the logic as needed
   function select_whileRecording_<%= id %>() {
       $("#select_record_<%= id %>").empty();
       $("#select_record_<%= id %>").append('<img style="object-fit: contain; display: block; height: 100%;" src="<%= micIconRecording %>" alt="microphone"/>');
        $("#select_record_<%= id %>").css("background-color", "red")
      //  $("#select_record_<%= id %>").css("color", "white")
    }

    // change the logic as needed
    function select_whenRecordingFinished_<%= id %>() {
    	 $("#select_record_<%= id %>").empty();
         $("#select_record_<%= id %>").append('<img style="object-fit: contain; display: block; height: 100%;" src="<%= micIconIdle %>" alt="microphone"/>');
      
        $("#select_record_<%= id %>").css("background-color", "white")
      //  $("#select_record_<%= id %>").css("color", "#333")
    }

    // change the logic as needed
    function select_whileLoading_<%= id %>() {
    	const selectionOption_<%= id %> = document.getElementById("select_output_<%= id %>");
    	selectionOption_<%= id %>.disabled = true;
        // console.log("Loading")
    }

    // change the logic as needed
    function select_whenFinished_<%= id %>() {
        // console.log("Finished")
    	selectionOption_<%= id %>.disabled = false;
    }

    
    // While Recording audio, call the whileRecording function 
    select_recorder_<%= id %>.on("recordingStarted", select_whileRecording_<%= id %>)
    // After recording audio stops, call whenRecordingFinished function
    select_recorder_<%= id %>.on("recordingStopped", select_whenRecordingFinished_<%= id %>)
    // While converting the recorded audio to text, call whileLoading function
    select_recorder_<%= id %>.on("isLoading", select_whileLoading_<%= id %>)
    // When conversion of audio to text is finished, call whenFinished function
    select_recorder_<%= id %>.on("isFinished", select_whenFinished_<%= id %>)

    // When the user clicks the mic button start recording by calling the recordNow function
    $("#select_record_<%= id %>").click(select_recordNow_<%= id %>);
</script>
