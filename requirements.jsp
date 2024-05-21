
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.7/axios.min.js" integrity="sha512-NQfB/bDaB8kaSXF8E77JjhHG5PM6XVRxvHzkZiwl3ddWCEPBa23T76MuWSwAJdMGJnmQqM0VeY9kFszsrBEFrQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/eventemitter3/5.0.1/index.min.js" integrity="sha512-2Ennqwp8s5F7iz0njdlWWKbd6bCby5nny78Wt9e9t780ErG6eb/vaFDkIt/j3EVhBXeCYH7uc0eFmOvc0EbwLA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script src="voice_input/scripts/library.js"></script>
<%-- <script src="https://kit.fontawesome.com/28d0d779f8.js" crossorigin="anonymous"></script> --%>

<%-- Voice Input --%>
<script>
    function domToString(element) {
        if (element.outerHTML) {
            return element.outerHTML;
        } else {
            const tagName = element.tagName.toLowerCase();
            const attributes = [...element.attributes].map(attr => attr.name + '="' + attr.value + '"').join(' ');
            const childrenString = element.innerHTML;
            return '<' + tagName + ' ' + attributes + '>' + childrenString + '</' + tagName + '>';
        }
    }

    function generateVoiceInputFieldWithMic(options) {
        const { id = "", lang = "ja", micIconIdle = "/voice_input/assets/microphone-solid.svg", micIconRecording = "/voice_input/assets/microphone-solid-white.svg", className = "", style = "", buttonStyle = "", buttonClassName = "", ...remainingAttributes} = options;

        // Generate unique ID using crypto (if not provided)
        const uniqueId = id || window.crypto.randomUUID().replace(/-/g, "") + id;

        // Create the span element
        const voiceInputSpan = document.createElement('span');
        voiceInputSpan.id = 'span' + uniqueId;
        voiceInputSpan.style.display = 'inline-flex';
        voiceInputSpan.style.alignItems = 'center';
        voiceInputSpan.style.gap = '2px';
        if (style) {
            voiceInputSpan.style.cssText += style;
        }

        // Create the input element
        const voiceInput = document.createElement('input');
        voiceInput.setAttribute("id", "output_" + uniqueId);
        voiceInput.style.minWidth = "10px";
        voiceInput.style.width = "100%";
        if(className) {
            voiceInput.setAttribute("class", className);
        }
        // Set all other attributes
        for (const [key, value] of Object.entries(remainingAttributes)) {
            voiceInput.setAttribute(key, value);
        }
        if (style) {
            voiceInput.style.cssText += style;
        }
        voiceInputSpan.appendChild(voiceInput);

        // Create the button element
        const recordButton = document.createElement('button');
        recordButton.style.display = 'inline-flex';
        recordButton.style.justifyContent = 'center';
        recordButton.style.alignItems = 'center';
        recordButton.style.height = '25px';
        recordButton.style.width = '40px';
        if (buttonStyle) {
            recordButton.style.cssText += buttonStyle;
        }
        recordButton.className = buttonClassName;
        recordButton.id = "record_" + uniqueId;
        voiceInputSpan.appendChild(recordButton);

        // Create the microphone icon
        const micIcon = document.createElement('img');
        micIcon.style.objectFit = 'contain';
        micIcon.style.display = 'block';
        micIcon.style.height = '100%';
        micIcon.src = micIconIdle;
        micIcon.alt = 'microphone';
        recordButton.appendChild(micIcon);

        // Create the script element
        const scriptContent = 
            "(() => { // [Mandatory] - Initialized the voice recorder\n" +
            "const recorder_" + uniqueId + " = new VoiceInput($(\"#output_" + uniqueId + "\"), \"" + lang + "\");\n\n" +
        
            "// [MANDATORY] - to call the startOrStopTranscription() \n" +
            "function recordNow_" + uniqueId + "() {\n" +
            "    recorder_" + uniqueId + ".startOrStopTranscription();\n" +
            "}\n\n" +

            "// Change the logic as needed\n" +
            "function whileRecording_" + uniqueId + "() {\n" +
            "    $(\"#record_" + uniqueId + "\").empty();\n" +
            "    $(\"#record_" + uniqueId + "\").append('<img style=\"object-fit: contain; display: block; height: 100%;\" src=\"" + micIconRecording + "\" alt=\"microphone\"/>');\n" +
            "    $(\"#record_" + uniqueId + "\").css(\"background-color\", \"red\");\n" +
            "}\n\n" +

            "// change the logic as needed\n" +
            "function whenRecordingFinished_" + uniqueId + "() {\n" +
            "    $(\"#record_" + uniqueId + "\").empty();\n" +
            "    $(\"#record_" + uniqueId + "\").append('<img style=\"object-fit: contain; display: block; height: 100%;\" src=\"" + micIconIdle + "\" alt=\"microphone\"/>');\n" +
            "    $(\"#record_" + uniqueId + "\").css(\"background-color\", \"white\");\n" +
            "}\n\n" +

            "// change the logic as needed\n" +
            "function whileLoading_" + uniqueId + "() {\n" +
            "    // console.log(\"Loading\");\n" +
            "}\n\n" +

            // When the input field is focused
            "$('#output_" + uniqueId +"').on('focus', function() {\n"+
            "    $(this).on('keydown', function(event) {\n" +
            "        if (event.keyCode === 13) {\n" +
            "            convertIntoPlainSpan();\n" +
            "        }\n" +
            "    });\n" +
            " });\n" +

            "$('#output_" + uniqueId +"').on('blur', function() {\n"+
            "    $(this).off('keydown');\n" +
            " });\n" +

            "function convertIntoPlainSpan() {\n" +
            "     const transcribedText = $(\"#output_" + uniqueId + "\").val();\n" +
            "     const updatedOptions = " + JSON.stringify({...options}) +";\n" +
            "     updatedOptions.value = transcribedText; \n" +
            "     const plainInputString = generateVoiceInputField(updatedOptions);     \n"+
            "     $('#span" + uniqueId + "').replaceWith(plainInputString);" +
            "}\n" +

            "// change the logic as needed\n" +
            "function whenFinished_" + uniqueId + "() {\n" +
            "    // console.log(\"Finished\");\n" +
            "    $(\"#output_" + uniqueId + "\").attr('readonly', false);\n" +
            "    convertIntoPlainSpan();\n" +
            "}\n\n" +

            "// While Recording audio, call the whileRecording function \n" +
            "recorder_" + uniqueId + ".on(\"recordingStarted\", whileRecording_" + uniqueId + ");\n" +
            "// After recording audio stops, call whenRecordingFinished function\n" +
            "recorder_" + uniqueId + ".on(\"recordingStopped\", whenRecordingFinished_" + uniqueId + ");\n" +
            "// While converting the recorded audio to text, call whileLoading function\n" +
            "recorder_" + uniqueId + ".on(\"isLoading\", whileLoading_" + uniqueId + ");\n" +
            "// When conversion of audio to text is finished, call whenFinished function\n" +
            "recorder_" + uniqueId + ".on(\"isFinished\", whenFinished_" + uniqueId + ");\n\n" +

            "// When the user clicks the mic button start recording by calling the recordNow function\n" +
            "$(\"#record_" + uniqueId + "\").click(recordNow_" + uniqueId + ");\n })()";

        const scriptElement = document.createElement('script');
        scriptElement.type = 'text/javascript';
        scriptElement.textContent = scriptContent;
        voiceInputSpan.appendChild(scriptElement);


        // Return the created span element
        return domToString(voiceInputSpan);
    }

    function generateVoiceInputField(options) {
        const { id = "", value = "", ...remainingAttributes} = options;

        // Generate unique ID using crypto (if not provided)
        const uniqueId = id || window.crypto.randomUUID().replace(/-/g, "") + id;

        // Create the span element
        const spanElement = document.createElement('span');
        spanElement.style.display = 'inline-block';
        spanElement.textContent = value;
        spanElement.id = uniqueId;
        if(spanElement.textContent === "") {
            spanElement.style.width = '100px';
            spanElement.style.height = '18px';
            spanElement.style.backgroundColor = '#ccc';
        }
        if (options?.style) {
            spanElement.style.cssText += options.style;
        }

        const hiddenElement = document.createElement('input');
        hiddenElement.type = 'hidden';
        hiddenElement.value = value;
        
         // Set all other attributes
        for (const [key, value] of Object.entries(remainingAttributes)) {
            hiddenElement.setAttribute(key, value);
        }

        spanElement.appendChild(hiddenElement);

        // Return the created span element

        const scriptElement = document.createElement('script');
        scriptElement.type = 'text/javascript';

        const scriptContent = 
            "$(document).ready(function() {" +
            "    $('#" + uniqueId + "').click(function() {" +
            "        const text = $('#" + uniqueId + "').text();" +
            "        const voiceInputInString = generateVoiceInputFieldWithMic(" + JSON.stringify({...options, id: uniqueId}) + ");" +
            "        $('#" + uniqueId + "').replaceWith(voiceInputInString);" +
            "    });" +
            "});";
        
        scriptElement.textContent = scriptContent;
        spanElement.appendChild(scriptElement);
        const spanDomString = domToString(spanElement);

        return spanDomString;
    }
</script>