window.rulesEditor = function() {

    // Init app
    window.app = new Vue({
        el: '#app',
        data: {
            currentTool: 'default',
            currentLogic: 'and',
            rules: gon.snek_rules
        },
        methods: {
            selectTool: function(event) {
                this.currentTool = event.target.dataset.tool;
            },

            selectLogic: function(event) {
                this.currentLogic = event.target.dataset.logic;
            },

            cellClass: function(x,y,z) {
                var classes = 'r-pattern-cell__' + this.rules[x][y][z][0];
                switch(this.rules[x][y][z][1]) {
                    case 'or':
                        classes += ' r-pattern-cell__or';
                        break;
                    case 'not':
                        classes += ' r-pattern-cell__not';
                        break;
                }
                return classes;
            },

            cellClassByTools: function(tool, logic) {
                if(!tool) {
                    tool = this.currentTool;
                }
                if(!logic) {
                    logic = this.currentLogic;
                }
                var classes = 'r-pattern-cell__' + tool;
                switch (logic) {
                    case 'or':
                        classes += ' r-pattern-cell__or';
                        break;
                    case 'not':
                        classes += ' r-pattern-cell__not';
                        break;
                }
                return classes;
            },

            setTool: function(data) {
                var $cell = $('#c_' + data.pattern + '_' + data.row + '_' + data.cell);
                switch(this.currentTool) {
                    case 'my_head':
                        if($cell[0] !== this.currentTool) {
                            // Find current my head and replace to default
                            for(var i = 0; i < this.rules[data.pattern].length; i++) {
                                for(var j = 0; j < this.rules[data.pattern][i].length; j++) {
                                    if(this.rules[data.pattern][i][j][0] === 'my_head') {
                                        this.rules[data.pattern][i][j][0] = 'default';
                                        this.rules[data.pattern][i][j][1] = 'and';
                                        $('#c_' + data.pattern + '_' + i + '_' + j).removeClass();
                                        $('#c_' + data.pattern + '_' + i + '_' + j).addClass( this.cellClassByTools('default', 'and') );
                                        break;
                                    }
                                }
                            }
                            // Set my head to new position
                            this.rules[data.pattern][data.row][data.cell][0] = this.currentTool;
                            this.rules[data.pattern][data.row][data.cell][1] = 'and';
                            $cell.removeClass();
                            $cell.addClass('r-pattern-cell__' + this.currentTool);
                        }
                        break;
                    case 'default':
                        if (this.rules[data.pattern][data.row][data.cell][0] !== 'my_head') {
                            this.rules[data.pattern][data.row][data.cell][0] = this.currentTool;
                            this.rules[data.pattern][data.row][data.cell][1] = 'and';
                            $cell.removeClass();
                            $cell.addClass( 'r-pattern-cell__default' );
                        }
                        break;
                    default:
                        // Do not change for the same cell or if current cell is my head
                        if (this.rules[data.pattern][data.row][data.cell][0] !== 'my_head') {
                            this.rules[data.pattern][data.row][data.cell][0] = this.currentTool;
                            this.rules[data.pattern][data.row][data.cell][1] = this.currentLogic;
                            $cell.removeClass();
                            $cell.addClass( this.cellClassByTools() );
                        }

                        break;

                }

                // Store to the form
                $('#snek_rules').val( JSON.stringify(this.rules) );

            }

        }
    });

    // On window resize
    $(document).ready(resizePatterns);
    $(window).resize(resizePatterns);

    // Resize patterns cells
    function resizePatterns() {
        $('.r-pattern-table').height($('.r-pattern-table').width());
        $('.r-pattern-table td').height($('.r-pattern-table td').width());
    }

};