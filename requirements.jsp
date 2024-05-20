
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.7/axios.min.js" integrity="sha512-NQfB/bDaB8kaSXF8E77JjhHG5PM6XVRxvHzkZiwl3ddWCEPBa23T76MuWSwAJdMGJnmQqM0VeY9kFszsrBEFrQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/eventemitter3/5.0.1/index.min.js" integrity="sha512-2Ennqwp8s5F7iz0njdlWWKbd6bCby5nny78Wt9e9t780ErG6eb/vaFDkIt/j3EVhBXeCYH7uc0eFmOvc0EbwLA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script src="voice_input/scripts/library.js"></script>
<%-- <script src="https://kit.fontawesome.com/28d0d779f8.js" crossorigin="anonymous"></script> --%>

<%-- Voice Input --%>
<script>
    function generateVoiceInputField(options) {
    const { id = "", lang = "ja", micIconIdle = "/voice_input/assets/microphone-solid.svg", micIconRecording = "/voice_input/assets/microphone-solid-white.svg", className = "", style = "", buttonStyle = "", buttonClassName = "", ...remainingAttributes} = options;

    // Generate unique ID using crypto (if not provided)
    const uniqueId = id || window.crypto.randomUUID().replace(/-/g, "") + id;

    // Create the span element
    const voiceInputSpan = document.createElement('span');
    voiceInputSpan.style.display = 'inline-flex';
    voiceInputSpan.style.alignItems = 'center';
    voiceInputSpan.style.gap = '2px';
    if (style) {
        voiceInputSpan.style.cssText += style;
    }

    // Create the input element
    const voiceInput = document.createElement('input');
    voiceInput.setAttribute("id", "output_" + uniqueId);
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
        "// [Mandatory] - Initialized the voice recorder\n" +
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

        "// change the logic as needed\n" +
        "function whenFinished_" + uniqueId + "() {\n" +
        "    // console.log(\"Finished\");\n" +
        "    $(\"#output_" + uniqueId + "\").attr('readonly', false);\n" +
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
        "$(\"#record_" + uniqueId + "\").click(recordNow_" + uniqueId + ");\n";

    const scriptElement = document.createElement('script');
    scriptElement.type = 'text/javascript';
    scriptElement.textContent = scriptContent;
    voiceInputSpan.appendChild(scriptElement);

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

    // Return the created span element
    return domToString(voiceInputSpan);
}
</script>