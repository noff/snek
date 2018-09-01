window.testPattern = function() {

    // Init app
    window.tester = new Vue({

        el: '#test-pattern',

        data: {
            pattern_id: null,
            battle_id: null,
            round_id: null,
            snek_id: null,

            pattern: null,
            round: null,
            arena: null,
            rounds: [],
            sneks: [],
            snek_names: [],
            test_result: null
        },

        methods: {

            // Opens test pattern dialog
            testPattern: function(id) {
                this.pattern_id = id;
                this.pattern = window.app.rules[id];
                this.drawPattern() // pattern instance might be the same, but contents changed
            },

            // Loads battle info and renders arena
            on_battle_changed: function() {
                this.battle_id = $('#battle-selector').val() || null;
            },

            on_snek_changed: function() {
                var snek = $('#snek-selector').val();
                this.snek_id = snek ? parseInt(snek) : null;
            },

            updateSnekSelector: function() {
                var snek_selector = $('#snek-selector');
                var options = "<option>&lt;None&gt;</option>";
                if (this.round == null) {
                    snek_selector.html(options);
                    return;
                }

                var sneks = this.round.sneks;
                var has_current = false;
                for (var i in sneks) {
                    if (sneks.hasOwnProperty(i)) {
                        var snekId = sneks[i].snek_id;
                        if (this.snek_id === snekId) {
                            has_current = true;
                        }
                        options += "<option value='" + snekId + "' " + (has_current ? 'selected' : '') + " >" + this.snek_names[snekId] + "</option>";
                    }
                }
                snek_selector.html(options);
                if (!has_current) {
                    this.snek_id = null;
                }
            },

            drawPattern: function() {
                var pattern = this.pattern
                if (pattern) {
                    var html = '<table class="r-pattern-table">';
                    pattern.forEach(function (row, y) {
                        html += "<tr>";
                        row.forEach(function (cell, x) {
                            var classes = 'r-pattern-cell r-pattern-cell__' + pattern[y][x][0];
                            switch (pattern[y][x][1]) {
                                case 'or':
                                    classes += ' r-pattern-cell__or';
                                    break;
                                case 'not':
                                    classes += ' r-pattern-cell__not';
                                    break;
                            }
                            html += "<td class='" + classes + "'></td>";
                        });
                        html += "</tr>";
                    });
                    html += '</table>';
                    $('#test-pattern-container').html(html);
                    $('#test-pattern-container .r-pattern-table').height(223);
                    $('#test-pattern-container .r-pattern-table').width(223);
                    $('#test-pattern-container .r-pattern-table td').height($('#test-pattern-container .r-pattern-table td').width());
                } else {
                    $('#test-pattern-container').empty();
                }
            },

            drawTestResult: function() {
                var text;
                if (this.test_result === null) {
                    text = ""
                } else  if (this.test_result.pattern === this.pattern_id) {
                    text = "This pattern matched as " + this.test_result.direction;
                } else if (this.test_result.pattern !== null) {
                    text = "This pattern didn't match";
                } else {
                    text = "None of the patterns matched";
                }
                $('#test-output').html(text);
            },

            drawRound: function() {
                if (this.round_id === null) {
                    $('#test-arena').empty();
                    return;
                }

                // Draw rounds selector
                $('#round-selector').prop('max', this.rounds.length - 1);

                // Draw arena
                var html = '';
                this.arena.forEach(function(row, y){
                    html += '<tr>';
                    row.forEach(function(cell, x) {
                        if(cell === 'wall') {
                            html += '<td class="wall"></td>';
                        } else {
                            html += '<td class="empty" id="c_' +  x + '_' + y + '"></td>';
                        }
                    });
                    html += '</tr>';
                });
                $('#test-arena').html(html);
                resizeArena();

                // Draw sneks on arena
                var _this = this;
                var direction_code = '';
                var cell_html = '';
                this.round.sneks.forEach(function(snek, snek_number){
                    snek.position.forEach(function (position, index) {
                        direction_code = _this.directionClass(index, snek);

                        var class_skin = '" class="' + direction_code + '"';
                        var class_body = '" class="' + direction_code ;
                        if (_this.snek_id === snek.snek_id) {
                            class_body += ' selected-snek"'
                        } else {
                            class_body += '"'
                        }

                        var cell = $('#c_' + position.x + '_' + position.y);
                        if(index === 0) {
                            cell_html = '<img src="' + _this.sneks[snek.snek_id].style.head + class_body + ' title="' + _this.sneks[snek.snek_id].name + '">';
                            cell.html(cell_html);
                        } else if (index !== (snek.position.length - 1) ) {
                            if( snek.position[index-1].x !== snek.position[index+1].x && snek.position[index-1].y !== snek.position[index+1].y ) {
                                cell_html = '<img src="' + _this.sneks[snek.snek_id].style.curve + class_body + '>';
                                cell_html += '<img src="' + _this.sneks[snek.snek_id].style.curve_pattern + class_skin + '>';
                                cell.html(cell_html);
                            } else {
                                cell_html = '<img src="' + _this.sneks[snek.snek_id].style.body + class_body + '>';
                                cell_html += '<img src="' + _this.sneks[snek.snek_id].style.body_pattern + class_skin + '>';
                                cell.html(cell_html);
                            }
                        } else {
                            cell_html = '<img src="' + _this.sneks[snek.snek_id].style.tail + class_body + '>';
                            cell_html += '<img src="' + _this.sneks[snek.snek_id].style.tail_pattern + class_skin + '>';
                            cell.html(cell_html);
                        }
                    });
                });

            },

            /**
             * Get cell direction CSS class
             */
            directionClass: function(position_index, snek_data) {
                var position = snek_data.position;
                var prev = position[position_index - 1];
                var curr = position[position_index];
                var next = position[position_index + 1];

                // Head
                if(prev == null) {
                    if (next.x === curr.x) {
                        if (next.y > curr.y) {
                            return 'cell-up';
                        } else {
                            return 'cell-down';
                        }
                    } else if (next.y === curr.y) {
                        if (next.x > curr.x) {
                            return 'cell-left';
                        } else {
                            return 'cell-right';
                        }
                    }
                }

                // Tail
                if (next == null) {
                    if (prev.x === curr.x) {
                        if (prev.y > curr.y) {
                            return 'cell-down';
                        } else {
                            return 'cell-up';
                        }
                    } else if (prev.y === curr.y) {
                        if (prev.x > curr.x) {
                            return 'cell-right';
                        } else {
                            return 'cell-left';
                        }
                    }
                }

                // Body
                if( prev && next && curr ) {
                    // Horizontal
                    if( prev.y === next.y ) {
                        return 'cell-left';
                        // Vertical
                    } else if (prev.x === next.x ) {
                        return 'cell-up';
                        // Will be curve
                    } else {

                        // Position ⌝. Don't rotate
                        if (prev.y === curr.y && prev.y < next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-left';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-left';
                        }

                        // Position ⌜.
                        if (prev.y === curr.y && prev.y < next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-down';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-down';
                        }

                        // Position ⌞.
                        if (prev.y === curr.y && prev.y > next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-right';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-right';
                        }

                        // Position ⌟.
                        if (prev.y === curr.y && prev.y > next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-up';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-up';
                        }

                    }

                }

                return '';
            },

            nextPattern: function(){
                if(this.pattern_id < 9)  {
                    this.pattern_id++;
                }
            },

            prevPattern: function() {
                if(this.pattern_id > 0) {
                    this.pattern_id--;
                }
            },

            nextRound: function(){
                if(this.round_id < (this.rounds.length - 1) ) {
                    this.round_id++;
                }
            },

            prevRound: function() {
                if(this.round_id > 0) {
                    this.round_id--;
                }
            },

            gotoBeginning: function(){
                this.round_id = 0;
            },

            gotoEnd: function(){
                this.round_id = this.rounds.length - 1;
            },

            findPattern: function() {
                this.performTest(true)
            },

            checkPattern: function() {
                this.performTest(false)
            },

            performTest: function(navigate) {
                var _this = this;

                var data = {
                    battle_id: this.battle_id,
                    round: this.round_id,
                    snek_id: this.snek_id,
                    pattern: JSON.stringify(this.pattern)
                };

                $.ajax({
                    dataType: "json",
                    url: '/sneks/test_pattern',
                    type: 'post',
                    data: data,
                    success: function(response) {
                        _this.test_result = {direction: response.direction, pattern: response.pattern, select: navigate}
                    }
                });
            },
        },

        watch: {
            battle_id: function (newId, _) {
                this.test_result = null;
                if (newId === null) {
                    this.round_id = null;
                    return;
                }

                var _this = this;
                $.ajax({
                    dataType: "json",
                    url: '/battles/' + this.battle_id + '/data',
                    data: {},
                    success: function (response) {
                        _this.rounds = response.rounds;
                        _this.arena = response.arena;
                        _this.snek_names = response.snek_names;
                        _this.sneks = response.sneks;
                        _this.round_id = 0;
                    }
                });
            },

            pattern_id: function(newId, _) {
                this.pattern = window.app.rules[newId];
                this.drawTestResult()
            },

            round_id: function(newId, _) {
                if (this.round_id === null) {
                    this.round = null;
                    return;
                }

                this.round = this.rounds[this.round_id]
            },

            snek_id: function(newValue, oldValue) {
                this.updateSnekSelector();
                this.drawRound();
                this.test_result = null;
            },

            round: function(newValue, oldValue) {
                this.updateSnekSelector();
                this.drawRound();
                this.test_result = null;
            },

            test_result: function (newValue, _) {
                if (newValue !== null && newValue.select && newValue.pattern !== null) {
                    this.pattern_id = newValue.pattern;
                }
                this.drawTestResult()
            },

            pattern: function(newPattern, _) {
                this.drawPattern()
            }
        }
    });

};